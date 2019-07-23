require "baked_file_system"
require "colorize"
require "crystal-rethinkdb"
require "json"
require "logger"
require "pool/connection"
require "router"

require "./explorer/logger"
require "./explorer/sync/*"
# require "./explorer/version"
require "./explorer/web/api"

L = Explorer::Logger.instance
NODE_URL = "http://localhost:3000"
NODE_WS_PUBSUB_URL = "ws://localhost:3000/pubsub"
WEBAPP_HOST = "0.0.0.0"
WEBAPP_PORT = 3100

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
Explorer::Sync::Blockchain.event(NODE_WS_PUBSUB_URL)

# Run the explorer web application
Explorer::Web::Api.new(WEBAPP_HOST, WEBAPP_PORT, L).run
