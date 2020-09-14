require "./types/*"

module Explorer
  class NodeApi
    include Explorer::Logger

    @@pool : ConnectionPool(HTTP::Client) = ConnectionPool.new(capacity: 5, timeout: 0.1) do
      HTTP::Client.new(URI.parse(CONFIG.node))
    end

    def self.pool
      @@pool
    end

    def self.last_block_index : Int64
      pool.connection do |http|
        http.exec(HTTP::Request.new("GET", "/api/v1/blockchain/size")) do |response|
          if response.status_code == 200
            json_str = response.body_io.gets
            if json_str && !json_str.strip.empty?
              return BlockchainSize.from_json(json_str).result["size"] - 1
            end
          else
            @@logger.warning "Node api (/api/v1/blockchain/size) failure"
          end
        end
      end
      0.to_u64
    rescue ex
      @@logger.warning "Can't retrieve block size: #{ex}"
      0.to_u64
    end

    def self.block(index : Int64) : Block?
      pool.connection do |http|
        http.exec(HTTP::Request.new("GET", "/api/v1/block/#{index}")) do |response|
          if response.status_code == 200
            json_str = response.body_io.gets
            if json_str && !json_str.strip.empty?
              return BlockResult.from_json(json_str).result
            end
          else
            @@logger.warning "Node api (/api/v1/block/#{index}) failure"
            return nil
          end
        end
      end
    rescue ex
      @@logger.warning "Can't retrieve the block: #{ex}"
      nil
    end

    def self.blockchain : Array(Block)?
      pool.connection do |http|
        http.exec(HTTP::Request.new("GET", "/api/v1/blockchain")) do |response|
          if response.status_code == 200
            json_str = response.body_io.gets
            if json_str && !json_str.strip.empty?
              return BlockchainResult.from_json(json_str).result
            end
          else
            @@logger.warning "Node api (/api/v1/blockchain) failure"
            return nil
          end
        end
      end
    rescue ex
      @@logger.warning "Can't retrieve the blockchain: #{ex}"
      nil
    end
  end

  include Explorer::Types
end
