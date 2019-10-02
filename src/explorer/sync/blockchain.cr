require "./../db/*"
require "./../node_api"

module Explorer
  module Sync
    class Blockchain
      # Initialize the chain at start
      def self.sync
        db_block_index = R.last_block_index
        node_block_index = NodeApi.last_block_index
        raise "Could not synchronize the database. Node is empty! [node_block_index == #{node_block_index}]" if node_block_index == 0
        L.debug "DB last index: #{db_block_index.inspect}"
        L.debug "Node last index: #{node_block_index.inspect}"
        if db_block_index != node_block_index
          # /!\ node_block_index - 1: last block is send and stored when connected to the /pubsub event
          node_block_index -= 1
          # Ensure to clean database if SushiChain node is on anoher chain or something is really bad !
          # Not safe for now, need a rewrite
          # if node_block_index < db_block_index
          #   R.clean_tables
          #   db_block_index = 0
          # end
          L.warn "Blockchain sync started..."
          Range.new(db_block_index, node_block_index).each do |iter|
            L.debug "Synchronizing block index #{iter}"
            block = NodeApi.block(iter.to_u64)
            L.debug "[Blockchain.sync] block to add: #{block}"
            R.block_add(block) if block
          end
          L.warn "Blockchain sync finished [#{(node_block_index - db_block_index) + 1} blocks added]..."
        else
          L.info "Blockchain is already synced..."
        end
      rescue ex
        L.error "[Explorer::Sync::Blockchain.sync] #{ex.message}"
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
            L.info "Block ##{block["index"]} added"
          end
        end

        socket.on_close do
          socket_close
        end

        L.info "Start listening block creation from SushiChain node websocket (#{ws_pubsub_url})..."
        begin
          socket.run
        rescue e : Exception
          L.error e.message.not_nil!
          socket_close
        end
      rescue ex
        L.error "[Explorer::Sync::Blockchain.event] #{ex.message}"
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
