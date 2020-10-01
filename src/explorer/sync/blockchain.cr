require "./../db/*"
require "./../node_api"

module Explorer
  module Sync
    class Blockchain
      include Explorer::Logger

      # Initialize the chain at start
      def self.sync
        # TODO(fenicks): sync from last block height (fast and slow)
        @@logger.info "Blockchain sync started"
        (NodeApi.blockchain || [] of Block).each do |block|
          R.block_add(block)
        end
        @@logger.info "Blockchain is synced now"
      rescue ex
        @@logger.error "[Explorer::Sync::Blockchain.sync] #{ex}"
        exit -42
      end

      # Axentro live update from node websocket
      def self.event(ws_pubsub_url : String)
        @@socket = HTTP::WebSocket.new(URI.parse(ws_pubsub_url))

        socket.on_message do |message|
          @@logger.debug "[Blockchain.event][raw message]: #{message}"
          block : Block = Block.from_json(message)
          if block.not_nil!
            R.block_add(block)
            @@logger.info "Block ##{block[:index]} added"
          end
        end

        socket.on_close do
          socket_close
        end

        @@logger.info "Start listening block creation from Axentro node websocket (#{ws_pubsub_url})..."
        begin
          socket.run
        rescue e : Exception
          @@logger.error "#{e}"
          socket_close
        end
      rescue ex
        @@logger.error "[Explorer::Sync::Blockchain.event] #{ex}"
      end

      private def self.socket
        @@socket.not_nil!
      end

      private def self.socket_close
        @@logger.warning "Axentro node socket closed"
      end
    end
  end
end
