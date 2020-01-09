require "baked_file_system"
require "colorize"
require "crystal-rethinkdb"
require "json"
require "logger"
require "option_parser"
require "pool/connection"
require "router"

require "./explorer/logger"
require "./explorer/sync/*"
# require "./explorer/version"
require "./explorer/web/api"

L = Explorer::Logger.instance

struct Config
  property node, node_pubsub, server, port, db, per_page

  def initialize(
    @node : String = "http://localhost:3000",
    @server : String = "0.0.0.0",
    @port : Int32 = 3100,
    @db : String = "rethinkdb://localhost:28015/explorer_testnet",
    @per_page = 20
  )
  end
end

CONFIG = Config.new

OptionParser.parse! do |parser|
  parser.banner = "Usage: explorer [arguments]"
  parser.on("-n NODE_URL", "--node=NODE_URL", "SushiChain node URL '#{CONFIG.node}' by default") { |node_url| CONFIG.node = node_url }
  parser.on("-s SERVER", "--server=SERVER", "Binding server host '#{CONFIG.server}' by default") { |server| CONFIG.server = server }
  parser.on("-p PORT", "--port=NAME", "Binding port '#{CONFIG.port}' by default") { |port| CONFIG.port = port.to_i32 }
  parser.on("-d DB_URL", "--db=DB_URL", "Database URL '#{CONFIG.db}' by default") { |db_uri| CONFIG.db = db_uri }
  parser.on("--per-page=PER_PAGE", "Number of lines for list pages '#{CONFIG.per_page}' by default") { |per_page| CONFIG.per_page = per_page.to_i32 }
  parser.on("--db-clean", "Drop tables and indexes") { R.db_cleanup }
  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
  end
end

# Database setup
begin
  R.db_setup
rescue ex
  L.error "[Database setup] #{ex} - #{ex.class}"
  exit -42
end

# SushiChain block live update from 'pubsub' SushiChain websocket
spawn do
  loop do
    begin
      Explorer::Sync::Blockchain.event("#{CONFIG.node}/pubsub")
    rescue ex
      L.error "[Explorer::Sync::Blockchain.event(\"#{CONFIG.node}/pubsub\")] #{ex}"
    end
    sleep 5.seconds
  end
end

# Node data synchronization
spawn do
  Explorer::Sync::Blockchain.sync
end

# Run the explorer web application
Explorer::Web::Api.new(CONFIG.server, CONFIG.port, L).run
