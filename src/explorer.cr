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
  property node, node_pubsub, host, port, db

  def initialize(
    @node : String = "http://localhost:3000",
    @node_pubsub : String = "ws://localhost:3000/pubsub",
    @host : String = "0.0.0.0",
    @port : Int32 = 3100,
    @db : String = "rethinkdb://sushixplorer:sushixplorer@localhost:28015/sushixplorer_test"
  )
  end
end

CONFIG = Config.new

OptionParser.parse! do |parser|
  parser.banner = "Usage: explorer [arguments]"
  parser.on("-n NODE_URL", "--node=NODE_URL", "Safe SushiChain node URL") { |node_url| CONFIG.node = node_url }
  parser.on("-s NODE_PUBSUB_URL", "--node-pubsub=NODE_PUBSUB_URL", "Safe SushiChain node pubsub URL") { |node_pubsub_url| CONFIG.node_pubsub = node_pubsub_url }
  parser.on("-h HOST", "--host=HOST", "Binding host, '#{CONFIG.host}' by default") { |host| CONFIG.host = host }
  parser.on("-p PORT", "--port=NAME", "Binding port. #{CONFIG.port} by default") { |port| CONFIG.port = port.to_i32 }
  parser.on("-d DB_URL", "--db=DB8URL", "Database URL. '#{CONFIG.db}' by default") { |db_uri| CONFIG.db = db_uri }
  parser.on("--help", "Show this help") { puts parser; exit 0 }
end

# Database setup
begin
  R.build_tables
  R.build_indexes
rescue ex
  L.error "[Database setup] #{ex.message}"
  exit -42
end

# Node data synchronization
begin
  Explorer::Sync::Blockchain.sync
rescue ex
  L.error "[Explorer::Sync::Blockchain.sync] #{ex.message}"
  exit -42
end

# SushiChain block live update
Explorer::Sync::Blockchain.event(CONFIG.node_pubsub)

# Run the explorer web application
Explorer::Web::Api.new(CONFIG.host, CONFIG.port, L).run
