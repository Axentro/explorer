require "json"
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
      include JSON::Serializable
      property status : String
      property result : JSON::Any
    end

    struct BlockResult
      include JSON::Serializable
      property status : String
      property result : Block
    end

    struct BlockchainResultData
      include JSON::Serializable
      property data : Array(Block)
    end

    struct BlockchainResult
      include JSON::Serializable
      property status : String
      property result : BlockchainResultData
    end
  end
end
