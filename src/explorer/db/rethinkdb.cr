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

      def self.add_block(block : Block)
        @@pool.connection do |conn|
          b = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS)
          if b.filter({index: block["index"]}).run(conn).size == 0
            b.insert(block).run(conn)
            t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS)
            block[:transactions].each do |tx|
              @@pool.connection do |t_conn|
                t.insert(tx).run(t_conn)
              end
            end
          end
        end
      end

      def self.add_blocks(blocks : Array(Block))
        blocks.each do |b|
          add_block(b)
        end
      end

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
          # ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).between(start, last, {index: "index"}).order_by(::RethinkDB.desc("index")).default("[]").run(conn)
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).order_by(::RethinkDB.desc("index")).slice(start, length).default("[]").run(conn)
        end.raw.to_json
      end

      def self.block(index : Int32)
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCKS).filter({index: index}).min("index").default("{}").run(conn)
        end.raw.to_json
      end

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

      # def self.transactions
      #   @@pool.connection do |conn|
      #     ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTIONS).order_by(::RethinkDB.desc("id")).default("[{}]").run(conn)
      #   end
      # end
      # def self.add_transaction(tr : Transaction)
      # def self.add_transactions(trs : Array(Transaction))
    end

    include Explorer::Types
  end
end

alias R = Explorer::Db::RethinkDB
