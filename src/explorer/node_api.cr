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

    def self.blockchain(page : Int32, per_page : Int32, direction : String) : Array(Block)?
      res = Array(Block).new
      pool.connection do |http|
        http.exec(HTTP::Request.new("GET", "/api/v1/blockchain?page=#{page}&per_page=#{per_page}&direction=#{direction}")) do |response|
          if response.status_code == 200
            json_str = response.body_io.gets
            if json_str && !json_str.strip.empty?
              res = res + BlockchainResult.from_json(json_str).result.data
            end
          else
            @@logger.warning "Node api (/api/v1/blockchain) failure"
            return nil
          end
        end
      end
      res
    rescue ex
      @@logger.warning "Can't retrieve the blockchain: #{ex}"
      nil
    end

    def self.address_tokens(address : String) : Hash(String, Float64)?
      pool.connection do |http|
        http.exec(HTTP::Request.new("GET", "/api/v1/address/#{address}")) do |response|
          if response.status_code == 200
            json_str = response.body_io.gets
            if json_str && !json_str.strip.empty?
              res = {} of String => Float64
              t = JSON.parse(json_str)
              t["result"]["pairs"].as_a.each do |pairs|
                res[pairs["token"].to_s] = pairs["amount"].as_s.to_f64
              end
              return res
            end
          else
            @@logger.warning "Node api (/api/v1/address/#{address}) failure"
            return nil
          end
        end
      end
    rescue ex
      @@logger.warning "Can't retrieve the tokens from the address(#{address}): #{ex}"
      nil
    end
  end

  include Explorer::Types
end
