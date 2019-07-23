module Explorer
  module Db
    class Memory
      def initialize
        @memory = Hash(String, String).new
      end

      def get(key : String) : String | Nil
        @memory[key]?
      end

      def [](*args)
        get(*args)
      end

      def set(key : String, value : String) : String
        @memory[key] = value
      end

      def []=(*args)
        set(*args)
      end

      def delete(key : String) : String
        @memory.delete(key)
      end

      def clear : Memory
        @memory.clear
        self
      end

      def each
        @memory.each
      end
    end
  end
end
