require "./../types/*"

module Explorer
  module Db
    class RethinkDB
      include ::RethinkDB::Shortcuts

      DB_URI = URI.parse(CONFIG.db)
      DB_NAME                   = DB_URI.path[1..-1]
      DB_TABLE_NAME_BLOCK       = "blocks"
      DB_TABLE_NAME_TRANSACTION = "transactions"
      DB_TABLE_LIST             = [DB_TABLE_NAME_BLOCK, DB_TABLE_NAME_TRANSACTION]

      # TODO(fenicks): Add connection parameter in Config static class who parameters are set in command line else in environment variables
      @@pool : ConnectionPool(::RethinkDB::Connection) = ConnectionPool.new(capacity: 5, timeout: 0.1) do
        ::RethinkDB.connect(
          host: DB_URI.host,
          port: DB_URI.port || 28015,
          db: DB_NAME,
          user: DB_URI.user,
          password: DB_URI.password
        )
      end

      def self.build_tables
        DB_TABLE_LIST.each do |table|
          build_table(table)
        end
      end

      def self.build_table(t : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table_list.run(conn).includes?(t)
            L.info "Table [#{t}] already exists"
          else
            ::RethinkDB.db(DB_NAME).table_create(t).run(conn)
            L.info "Table [#{t}] created"
          end
        end
      end

      def self.build_indexes
        DB_TABLE_LIST.each do |table|
          build_index("index", table)
        end
      end

      def self.build_index(index_field : String, table : String)
        @@pool.connection do |conn|
          if ::RethinkDB.db(DB_NAME).table(table).index_list.run(conn).includes?(index_field)
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
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCK).pluck("index").max("index").default({"index": 0}).run(conn)
        end
        (res["index"].try(&.to_s) || 0).to_u64
      end

      def self.add_block(block : Block)
        @@pool.connection do |conn|
          t = ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCK)
          if t.filter({index: block["index"]}).run(conn).size == 0
            t.insert(block).run(conn)
          end
        end
      end

      def self.add_blocks(blocks : Array(Block))
        blocks.each do |b|
          add_block(b)
        end
      end

      def self.blocks
        @@pool.connection do |conn|
          # ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCK).without("transactions").order_by(::RethinkDB.desc("index")).default("[{}]").run(conn)
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCK).order_by(::RethinkDB.desc("index")).default("[{}]").run(conn)
        end
      end

      # Transaction
      def self.transactions
        @@pool.connection do |conn|
          ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_BLOCK).pluck("transactions").order_by(::RethinkDB.desc("transactions.id")).default("[{}]").run(conn)
        end
      end
      # def self.transactions
      #   @@pool.connection do |conn|
      #     ::RethinkDB.db(DB_NAME).table(DB_TABLE_NAME_TRANSACTION).order_by(::RethinkDB.desc("id")).default("[{}]").run(conn)
      #   end
      # end
      # def self.add_transaction(tr : Transaction)
      # def self.add_transactions(trs : Array(Transaction))
    end

    include Explorer::Types
  end
end

alias R = Explorer::Db::RethinkDB
