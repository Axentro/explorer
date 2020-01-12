require "./../types/transaction"

module Explorer
  module Types
    alias FastBlock = NamedTuple(
      index: UInt64,
      transactions: Array(Transaction),
      prev_hash: String,
      merkle_tree_root: String,
      timestamp: Int64,
      kind: String,
      address: String,
      public_key: String,
      sign_r: String,
      sign_s: String,
      hash: String,
    )

    alias SlowBlock = NamedTuple(
      index: UInt64,
      transactions: Array(Transaction),
      nonce: UInt64|String,
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
        result: NamedTuple(size: UInt64),
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
