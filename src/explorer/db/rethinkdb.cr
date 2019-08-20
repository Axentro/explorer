require "./../types/*"

module Explorer
  module Db
    class RethinkDB
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
          host: DB_URI.host,
          port: DB_URI.port,
          db: DB_NAME,
          user: DB_URI.user,
          password: DB_URI.password
        )
      end

      def self.setup_database
        build_tables
        build_indexes
      end

      def self.build_tables
        DB_TABLE_LIST.each do |table|
          build_table(table)
        end
      end

      def self.build_table(t : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table_list.run(conn).as_a.includes?(t)
            L.info "Table [#{t}] already exists"
          else
            ::RethinkDB.db(DB_NAME).table_create(t).run(conn)
            L.info "Table [#{t}] created"
          end
        end
      end

      def self.build_indexes
        # Blocks
        build_index("index", DB_TABLE_NAME_BLOCKS)

        # Transactions
        build_index("timestamp", DB_TABLE_NAME_TRANSACTIONS)

        # Addresses
        build_index("name", DB_TABLE_NAME_ADDRESSES)

        # Domains
        build_index("name", DB_TABLE_NAME_DOMAINS)

        # Tokens
        build_index("name", DB_TABLE_NAME_TOKENS)
      end

      def self.build_index(index_field : String, table : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table(table).index_list.run(conn).as_a.includes?(index_field)
            L.info "Index [#{index_field}] already exists"
          else
            ::RethinkDB.db(DB_NAME).table(table).index_create(index_field).run(conn)
            L.info "Table [#{index_field}] created"
          end
        end
      end

      def self.clean_table(t : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(t).delete.run(conn)
          L.info "Table [#{t}] cleaned"
        end
      end

      def self.clean_tables
        DB_TABLE_LIST.each do |table|
          clean_table(table)
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
        # Insert the block
        b = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS)
        @@pool.connection do |conn|
          if b.filter({index: block[:index]}).run(conn).size == 0
            b.insert(block).run(conn)
            # Add block_index field in each transaction
            # TODO(fenicks): If Mint Maybe(Transaction) i fixed, try to do a less consuming insert: directly in transation source object ? @see "Add Transaction"
            b.filter({index: block[:index]}).update do |doc|
              {
                transactions: doc[:transactions].merge({block_index: block[:index]}),
              }
            end.run(conn)
          end
        end

        # Add default SUSHI token
        token_add({name: "SUSHI", timestamp: block[:timestamp]}) if block[:index] == 0

        # Add transaction
        t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS)
        @@pool.connection do |conn|
          t.insert(b.filter({index: block[:index]}).pluck("transactions").coerce_to("array")[0]["transactions"]).run(conn)
        end

        block[:transactions].each do |tx|
          # Add token created
          token_add({name: tx[:token], timestamp: tx[:timestamp]}) if tx[:action] == "create_token"

          # TODO(fenicks): Add collected addresses

          # TODO(fenicks): Add collected human readable address (SCARS/domains)
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
            ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).order_by(::RethinkDB.desc("index")).default("[]").run(conn)
          else
            ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).order_by(::RethinkDB.desc("index")).default("[]").limit(top).run(conn)
          end
        end.raw.to_json
      end

      def self.blocks(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          L.debug("[blocks] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          L.debug("[blocks] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).order_by(::RethinkDB.desc("index")).slice(start, length).default("[]").run(conn)
        end.raw.to_json
      end

      def self.block(index : Int32)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).filter({index: index}).min("index").default("{}").run(conn)
        end.raw.to_json
      end

      # Token
      def self.tokens
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS).order_by(::RethinkDB.asc("timestamp")).default("[]").run(conn)
        end.raw.to_json
      end

      def self.tokens(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          L.debug("[tokens] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          L.debug("[tokens] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS).order_by(::RethinkDB.asc("timestamp")).slice(start, last).default("[]").run(conn)
        end.raw.to_json
      end

      def self.token(name : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS).filter({name: name}).min("name").default("{}").run(conn)
        end.raw.to_json
      end

      def self.token_add(token : Token)
        @@pool.connection do |conn|
          t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TOKENS)
          if t.filter({name: token[:name]}).run(conn).size == 0
            t.insert(token).run(conn)
            L.debug("[#{DB_TABLE_NAME_TOKENS}] added: #{token[:name]}")
          end
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
            ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).order_by(::RethinkDB.desc("timestamp")).default("[]").run(conn)
          else
            ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).order_by(::RethinkDB.desc("timestamp")).default("[]").limit(top).run(conn)
          end
        end.raw.to_json
      end

      def self.transactions(page : Int32, length : Int32)
        @@pool.connection do |conn|
          page = 1 if page <= 0
          length = CONFIG.per_page if length < 0
          L.debug("[transactions] page: #{page} - length: #{length}")

          start = (page - 1) * length
          last = start + length
          L.debug("[transactions] start: #{start} - last: #{last}")
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).order_by(::RethinkDB.desc("timestamp")).slice(start, last).default("[]").run(conn)
        end.raw.to_json
      end

      def self.transaction(txid : String)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).get(txid).default("{}").run(conn)
        end.raw.to_json
      end
    end

    include Explorer::Types
  end
end

alias R = Explorer::Db::RethinkDB
