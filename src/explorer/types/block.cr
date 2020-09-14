require "./../types/transaction"

module Explorer
  module Types
    alias FastBlock = NamedTuple(
      index: Int64,
      transactions: Array(Transaction),
      prev_hash: String,
      merkle_tree_root: String,
      timestamp: Int64,
      kind: String,
      address: String,
      public_key: String,
      signature: String,
      hash: String,
    )

    alias SlowBlock = NamedTuple(
      index: Int64,
      transactions: Array(Transaction),
      nonce: String,
      prev_hash: String,
      merkle_tree_root: String,
      timestamp: Int64,
      difficulty: Int32,
      kind: String,
      address: String,
    )

    alias Block = FastBlock | SlowBlock

    struct BlockchainSize
      JSON.mapping(
        status: String,
        result: NamedTuple(size: Int64),
      )
    end

    struct BlockResult
      JSON.mapping(
        status: String,
        result: Block,
      )
    end

    struct BlockchainResult
      JSON.mapping(
        status: String,
        result: Array(Block),
      )
    end
  end
end
