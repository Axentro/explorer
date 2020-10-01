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

    def self.block_total_size : Int64
      pool.connection do |http|
        http.exec(HTTP::Request.new("GET", "/api/v1/blockchain/size")) do |response|
          if response.status_code == 200
            json_str = response.body_io.gets
            if json_str && !json_str.strip.empty?
              return BlockchainSize.from_json(json_str).result["totals"]["total_size"].as_i64
            end
          else
            @@logger.warning "Node api (/api/v1/blockchain/size) failure"
          end
        end
      end
      0.to_i64
    rescue ex
      @@logger.warning "Can't retrieve block size: #{ex}"
      0.to_i64
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
      total_size = block_total_size
      per_page = 20
      max_page = (total_size / per_page).ceil
      res = Array(Block).new
      (0..max_page).each do |page|
        pool.connection do |http|
          http.exec(HTTP::Request.new("GET", "/api/v1/blockchain?page=#{page}")) do |response|
            if response.status_code == 200
              json_str = response.body_io.gets
              if json_str && !json_str.strip.empty?
                res = res + BlockchainResult.from_json(json_str).result
              end
            else
              @@logger.warning "Node api (/api/v1/blockchain) failure"
              return nil
            end
          end
        end
      end
      res
    rescue ex
      @@logger.warning "Can't retrieve the blockchain: #{ex}"
      nil
    end
  end

  include Explorer::Types
end
