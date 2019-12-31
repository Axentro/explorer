require "./../db/*"
require "./../node_api"

module Explorer
  module Sync
    class Blockchain
      # Initialize the chain at start
      def self.sync
        L.info "Blockchain sync started"
        (NodeApi.blockchain || [] of Block).each do |block|
          R.block_add(block)
        end
        L.info "Blockchain is synced now"
      rescue ex
        L.error "[Explorer::Sync::Blockchain.sync] #{ex}"
        exit -42
      end

      # TODO(fenicks): write a new sync method who check all blocks and transactions at startup and rebuild addresses stored
      # TODO(fenicks): invoke sync method only if "--sync-db" or "-s" is specified in command line
      # TODO(fenicks): we need block comparison or block validation mecanism ?
      # def self.sync_db
      #   node_block_index = NodeApi.last_block_index
      #   Range.new(0, node_block_index).each do |iter|
      #   end
      # end

      # SushiChain live update from node websocket
      def self.event(ws_pubsub_url : String)
        @@socket = HTTP::WebSocket.new(URI.parse(ws_pubsub_url))

        socket.on_message do |message|
          L.debug "[Blockchain.event][raw message]: #{message}"
          block : Block = Block.from_json(message)
          if block.not_nil!
            R.block_add(block)
            L.info "Block ##{block[:index]} added"
          end
        end

        socket.on_close do
          socket_close
        end

        L.info "Start listening block creation from SushiChain node websocket (#{ws_pubsub_url})..."
        begin
          socket.run
        rescue e : Exception
          L.error "#{e}"
          socket_close
        end
      rescue ex
        L.error "[Explorer::Sync::Blockchain.event] #{ex}"
      end

      private def self.socket
        @@socket.not_nil!
      end

      private def self.socket_close
        L.warn "SushiChain node socket closed"
      end
    end
  end
end
