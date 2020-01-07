require "big"

require "./../types/*"

module Explorer
  module Db
    class RethinkDB
      include Explorer::Logger
      include ::RethinkDB::Shortcuts

      DB_URI                     = URI.parse(CONFIG.db)
      DB_NAME                    = DB_URI.path[1..-1]
      DB_TABLE_NAME_BLOCKS       = "blocks"
      DB_TABLE_NAME_TRANSACTIONS = "transactions"
      DB_TABLE_NAME_ADDRESSES    = "addresses"
      DB_TABLE_NAME_DOMAINS      = "domains"
      DB_TABLE_NAME_TOKENS       = "tokens"
      DB_TABLE_LIST              = [DB_TABLE_NAME_BLOCKS,
                                    DB_TABLE_NAME_TRANSACTIONS,
                                    DB_TABLE_NAME_ADDRESSES,
                                    DB_TABLE_NAME_DOMAINS,
                                    DB_TABLE_NAME_TOKENS]

      @@pool : ConnectionPool(::RethinkDB::Connection) = ConnectionPool.new(capacity: 10, timeout: 0.1) do
        ::RethinkDB.connect(
          host: DB_URI.host || "localhost",
          port: DB_URI.port || 28015,
          db: DB_NAME,
          user: DB_URI.user || "explorer_testnet",
          password: DB_URI.password || "explorer_testnet"
        )
      end

      def self.db_setup
        @@pool.connection do |conn|
          unless ::RethinkDB.db_list.run(conn).as_a.includes?(DB_NAME)
            @@logger.warning "Database [#{DB_NAME}] doesn't exist"
            ::RethinkDB.db_create(DB_NAME).run(conn)
            @@logger.info "Database [#{DB_NAME}] create"
          end
        end
        build_tables
        build_indexes
      end

      def self.db_cleanup
        DB_TABLE_LIST.each do |table|
          @@pool.connection do |conn|
            ::RethinkDB.db(DB_NAME).table(table).index_list.run(conn).as_a.each do |idx|
              ::RethinkDB.db(DB_NAME).table(table).index_drop(idx.to_s).run(conn)
              @@logger.info "Index [#{idx}] from the table [#{table}] droped"
            end
            ::RethinkDB.db(DB_NAME).table_drop(table).run(conn)
            @@logger.info "Table [#{table}] droped"
          end
        end
      rescue e
        @@logger.warning "Error when droping tables and their indexes: #{e}"
      end

      def self.build_tables
        DB_TABLE_LIST.each do |table|
          build_table(table)
        end
      end

      def self.build_table(t : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table_list.run(conn).as_a.includes?(t)
            @@logger.info "Table [#{t}] already exists"
          else
            ::RethinkDB.db(DB_NAME).table_create(t).run(conn)
            @@logger.info "Table [#{t}] created"
          end
        end
      end

      def self.build_indexes
        # Blocks
        build_index("index", DB_TABLE_NAME_BLOCKS)

        # Transactions
        build_index("timestamp", DB_TABLE_NAME_TRANSACTIONS)

        # Addresses
        build_index("address", DB_TABLE_NAME_ADDRESSES)
        build_index("amount", DB_TABLE_NAME_ADDRESSES)
        # TODO(fenicks): Fix RethinkDB driver to support slice after
        # build_index("amount_length", DB_TABLE_NAME_ADDRESSES) do |doc|
        #   doc["amount"].split("").count
        # end
        build_index("timestamps", DB_TABLE_NAME_ADDRESSES)

        # Domains
        build_index("name", DB_TABLE_NAME_DOMAINS)
        build_index("address", DB_TABLE_NAME_DOMAINS)

        # Tokens
        build_index("name", DB_TABLE_NAME_TOKENS)
      end

      # TODO(fenicks): FIXME ; try in a same method an optional block parameter to avoid code duplication ?
      def self.build_index(index_field : String, table : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table(table).index_list.run(conn).as_a.includes?(index_field)
            @@logger.info "Index [#{index_field}] already exists"
          else
            ::RethinkDB.db(DB_NAME).table(table).index_create(index_field).run(conn)
            @@logger.info "Index [#{index_field}] created"
          end
        end
      end

      # TODO(fenicks): FIXME ; try in a same method an optional block parameter to avoid code duplication ?
      def self.build_index(index_field : String, table : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table(table).index_list.run(conn).as_a.includes?(index_field)
            @@logger.info "Index [#{index_field}] already exists"
          else
            ::RethinkDB.db(DB_NAME).table(table).index_create(index_field) do |doc|
              yield(doc)
            end.run(conn)
            @@logger.info "Index [#{index_field}] created"
          end
        end
      end

      # Address
      def self.addresses
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_ADDRESSES)
            .map do |doc|
              doc.merge({domains: ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS).filter({address: doc["address"]}).coerce_to("array")})
            end
            .order_by(::RethinkDB.desc("timestamp")).default("[]").run(conn)
        end.to_json
      end

      def self.addresses(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          @@logger.debug("[addresses] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          @@logger.debug("[addresses] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_ADDRESSES)
            .map do |doc|
              doc.merge({domains: ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS).filter({address: doc["address"]}).coerce_to("array")})
            end
            # TODO(fenicks): Fix order_by(:field, index: :my_index) in rethinkdb crystal driver
            # .order_by(:amount, index: ::RethinkDB.desc("amount_length"))
            .order_by(::RethinkDB.desc("amount"))
            .slice(start, last)
            .default("{}")
            .run(conn)
        end.to_json
      rescue e
        @@logger.error "#{e}"
      end

      def self.address(address : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_ADDRESSES).filter({address: address}).map do |doc|
            doc.merge({domains: ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS).filter({address: doc["address"]}).coerce_to("array")})
          end.min("address").default("{}").run(conn)
        end.to_json
      end

      def self.address_add(who : String, token : String, address : String, amount : String, timestamp : Int64, fee : String = "0")
        a = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_ADDRESSES)
        @@pool.connection do |conn|
          if token == "AXE"
            if a.filter({address: address}).run(conn).size == 0
              # TODO(fenicks): discuss about first time address is shown fee must be zero ? If so remove the: `- BigInt.new(fee)` !
              a.insert({address: address, amount: (BigInt.new(amount) - BigInt.new(fee)).to_s, token_amounts: [] of TokenAmount, timestamp: timestamp}).run(conn)
              @@logger.debug "[NEW ADDRESS]: #{address} - [#{token}] - [AMOUNT]: #{who == "sender" ? "-" : "+"}#{amount} - [FEE:AXE] #{fee}"
            else
              # TODO(fenicks): Fix getting value in update RethinkDB update block
              result = a.filter({address: address}).run(conn).to_a.first
              a.filter({address: address}).update({durability: "hard"}) do
                result_amount : BigInt = if who == "sender"
                  BigInt.new(result["amount"].to_s) - (BigInt.new(amount) + BigInt.new(fee))
                else
                  BigInt.new(result["amount"].to_s) + BigInt.new(amount) # - BigInt.new(fee)
                end
                {amount: result_amount.to_s}
              end.run(conn)
              @@logger.debug "[UPDATE ADDRESS]: #{address} - [#{token}] - [AMOUNT]: #{who == "sender" ? "-" : "+"}#{amount} - [FEE:AXE] #{fee}"
            end
          else # tokens
            token_amount = amount
            if a.filter({address: address}).run(conn).size == 0
              a.insert({address: address, amount: "0", token_amounts: [{token: token, amount: token_amount}], timestamp: timestamp}).run(conn)
              @@logger.debug "[NEW ADDRESS]: #{address} - [NEW TOKEN] - #{token} - [AMOUNT]: #{who == "sender" ? "-" : "+"}#{token_amount} - [FEE:AXE] #{fee}"
            else
              if a.filter({address: address}).concat_map { |doc| doc[:token_amounts] }.filter({token: token}).run(conn).size == 0
                # TODO(fenicks): Fix getting value in update RethinkDB update block
                result = a.filter({address: address}).run(conn).to_a.first
                a.filter({address: address}).update({durability: "hard"}) do |u|
                  {
                    amount:        (BigInt.new(result["amount"].to_s) - BigInt.new(fee)).to_s,
                    token_amounts: u[:token_amounts].append({token: token, amount: token_amount}),
                  }
                end.run(conn)
                @@logger.debug "[UPDATE ADDRESS]: #{address} - [NEW TOKEN] - #{token} - [AMOUNT]: #{who == "sender" ? "-" : "+"}#{token_amount} - [FEE:AXE] #{fee}"
              else
                result = a.filter({address: address}).run(conn).to_a.first
                rt_amount : String
                rt_total : String
                result_token_amounts = a.filter({address: address}).concat_map { |addr| addr["token_amounts"] }.run(conn).to_a.map do |rt|
                  rt_amount = rt["amount"].to_s
                  rt_total = if who == "sender"
                               (BigInt.new(rt_amount) - BigInt.new(token_amount)).to_s
                             else
                               (BigInt.new(rt_amount) + BigInt.new(token_amount)).to_s
                             end
                  {amount: (rt["token"].to_s != token ? rt_amount : rt_total), token: rt["token"].as_s}
                end

                a.filter({address: address}).update({durability: "hard"}) do
                  {amount: (BigInt.new(result["amount"].to_s) - BigInt.new(fee)).to_s, token_amounts: result_token_amounts.to_a}
                end.run(conn)
                @@logger.debug "[UPDATE ADDRESS]: #{address} - [EXISTING TOKEN] - #{token} - [AMOUNT]: #{who == "sender" ? "-" : "+"}#{token_amount} - [FEE:AXE] #{fee}"
              end
            end
          end
        end
      end

      # Block
      def self.last_block_index : UInt64
        res = @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).pluck("index").max("index").default({"index": 0}).run(conn)
        end
        (res["index"].try(&.to_s) || 0).to_u64
      end

      def self.block_add(block : Block)
        scaled_block = scale_decimal(block)

        # Add default AXE token
        token_add({name: "AXE", timestamp: 0.to_i64}) if scaled_block[:index] == 0

        # Insert the block
        b = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS)
        @@pool.connection do |conn|
          if b.filter({index: scaled_block[:index]}).run(conn).size == 0
            begin
              b.insert(scaled_block).run(conn)
            rescue e
              @@logger.warning "[BLOCK:#{scaled_block[:index]}]: #{e}"
              @@logger.warning "#{scaled_block}"
            end
          end
        end

        # Add transaction
        t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS)
        @@pool.connection do |conn|
          t.insert(b.filter({index: scaled_block[:index]}).pluck("transactions").coerce_to("array")[0]["transactions"]).run(conn)
        end

        scaled_block[:transactions].each do |tx|
          # Add token created
          token_add({name: tx[:token], timestamp: tx[:timestamp]}) if tx[:action] == "create_token"

          # Add collected addresses
          tx[:senders].each do |s|
            amount = s[:amount]
            amount = "0" if tx[:action] == "create_token"
            address_add("sender", tx[:token], s[:address], amount, tx[:timestamp], s[:fee])
            @@logger.debug "[CREATE TOKEN SENDER] : #{tx[:token]}, #{s[:address]}, amount:#{amount}, fee:#{s[:fee]}" if tx[:action] == "create_token"
          end

          tx[:recipients].each do |r|
            address_add("recipient", tx[:token], r[:address], r[:amount], tx[:timestamp])
            @@logger.debug "[CREATE TOKEN RECIPIENT] : #{tx[:token]}, #{r[:address]}, amount:#{r[:amount]}" if tx[:action] == "create_token"
          end

          # TODO(fenicks): Add collected human readable address (SCARS/domains)
          if tx[:action] == "scars_buy"
            domain_address = tx[:senders].first?.try(&.[:address])
            domain_add({name: tx[:message], address: domain_address, timestamp: tx[:timestamp]}) if domain_address
          end
        end
      end

      # def self.blocks_add(blocks : Array(Block))
      #   blocks.each do |b|
      #     block_add(b)
      #   end
      # end

      def self.blocks(top : Int32 = -1)
        @@pool.connection do |conn|
          if top < 0
            top = CONFIG.per_page
          end
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).order_by(::RethinkDB.desc("index")).default("[]").limit(top).run(conn)
        end.to_json
      end

      def self.blocks(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          @@logger.debug("[blocks] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          @@logger.debug("[blocks] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).order_by(::RethinkDB.desc("index")).slice(start, last).default("[]").run(conn)
        end.to_json
      end

      def self.blocks_count
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).count.run(conn)
        end.to_json
      end

      def self.block(index : Int32)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).filter({index: index}).min("index").default("{}").run(conn)
        end.to_json
      end

      # Domain (Scars): scars_buy, scars_sell, scars_cancel
      def self.domains
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS).order_by(::RethinkDB.asc("timestamp")).default("[]").run(conn)
        end.to_json
      end

      def self.domains(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          @@logger.debug("[domains] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          @@logger.debug("[domains] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS).order_by(::RethinkDB.asc("timestamp")).slice(start, last).default("[]").run(conn)
        end.to_json
      end

      def self.domain(name : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS).filter({name: name}).min("name").default("{}").run(conn)
        end.to_json
      end

      def self.domain_add(domain : Domain)
        @@pool.connection do |conn|
          t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_DOMAINS)
          if t.filter({name: domain[:name]}).run(conn).size == 0
            t.insert(domain).run(conn)
            @@logger.debug("[#{DB_TABLE_NAME_DOMAINS}] added: #{domain[:name]}")
          else
            t.filter({name: domain[:name]}).update({address: domain[:address]}).run(conn)
            @@logger.debug("[#{DB_TABLE_NAME_DOMAINS}] updated: #{domain[:address]} to #{domain[:name]}")
          end
        end
      end

      # Token
      def self.tokens
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS).order_by(::RethinkDB.asc("timestamp")).default("[]").run(conn)
        end.to_json
      end

      def self.tokens(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          @@logger.debug("[tokens] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          @@logger.debug("[tokens] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS).order_by(::RethinkDB.asc("timestamp")).slice(start, last).default("[]").run(conn)
        end.to_json
      end

      def self.token(name : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS).filter({name: name}).min("name").default("{}").run(conn)
        end.to_json
      end

      def self.token_add(token : Token)
        @@pool.connection do |conn|
          t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS)
          return if t.filter({name: token[:name]}).run(conn).size > 0
          t.insert(token).run(conn)
          @@logger.debug("[#{DB_TABLE_NAME_TOKENS}] added: #{token[:name]}")
        end
      end

      # def self.tokens_add(transactions : Array(Transaction))
      #   transactions.each do |t|
      #     token_add(t)
      #   end
      # end

      # Transaction
      def self.transactions(top : Int32 = -1)
        @@pool.connection do |conn|
          if top < 0
            top = CONFIG.per_page
          end
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).order_by(::RethinkDB.desc("timestamp")).default("[]").limit(top).run(conn)
        end.to_json
      end

      def self.transactions(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          @@logger.debug("[transactions] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          @@logger.debug("[transactions] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).order_by(::RethinkDB.desc("timestamp")).slice(start, last).default("[]").run(conn)
        end.to_json
      end

      def self.transaction(txid : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).get(txid).default("{}").run(conn)
        end.to_json
      end

      def self.scale_decimal(block : Block)
        {
          index:        block[:index],
          transactions: block[:transactions].map do |t|
            {
              id:          t[:id],
              block_index: block[:index],
              action:      t[:action],
              senders:     t[:senders].map do |s|
                {
                  address:    s[:address],
                  public_key: s[:public_key],
                  amount:     s[:amount].to_s,
                  fee:        s[:fee].to_s,
                  sign_r:     s[:sign_r],
                  sign_s:     s[:sign_s],
                }
              end,
              recipients: t[:recipients].map do |r|
                {
                  address: r[:address],
                  amount:  r[:amount].to_s,
                }
              end,
              message:   t[:message],
              token:     t[:token],
              prev_hash: t[:prev_hash],
              timestamp: t[:timestamp],
              scaled:    t[:scaled],
              kind:      t[:kind],
            }
          end,
          nonce:            block[:nonce]?.try(&.to_s), # Needed because JSON (RethinkDB) doesn't support UInt64 type,
          prev_hash:        block[:prev_hash],
          merkle_tree_root: block[:merkle_tree_root],
          timestamp:        block[:timestamp],
          difficulty:       block[:difficulty]?,
          kind:             block[:kind],
          address:          block[:address],
          public_key:       block[:public_key]?,
          sign_r:           block[:sign_r]?,
          sign_s:           block[:sign_s]?,
          hash:             block[:hash]?,
        }
      end

      include Explorer::Types
    end
  end
end

alias R = Explorer::Db::RethinkDB
