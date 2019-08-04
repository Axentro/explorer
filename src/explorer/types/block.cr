require "./../types/transaction"

module Explorer
  module Types
    alias Block = NamedTuple(
      index: UInt64,
      transactions: Array(Transaction),
      nonce: UInt64,
      prev_hash: String,
      merkle_tree_root: String,
      timestamp: Int64,
      difficulty: Int32,
    )

    struct BlockchainSize
      JSON.mapping(
        status: String,
        result: NamedTuple(size: UInt64)
      )
    end

    struct BlockResult
      JSON.mapping(
        status: String,
        result: Block
      )
    end
  end
end
