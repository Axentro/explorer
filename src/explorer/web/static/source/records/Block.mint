record Block {
  index : Number,
  transactions : Array(Transaction),
  nonce : Number,
  prevHash : String using "prev_hash",
  merkleTreeRoot : String using "merkle_tree_root",
  timestamp : Number,
  difficulty : Number
}

module Block {
  fun empty : Block {
    {
      index = -1,
      transactions = [],
      nonce = 0,
      prevHash = "",
      merkleTreeRoot = "",
      timestamp = 0,
      difficulty = 0
    }
  }

  fun decode (object : Object) : Result(Object.Error, Block) {
    decode object as Block
  }
}
