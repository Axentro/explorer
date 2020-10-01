record Block {
  index : Number,
  transactions : Array(Transaction),
  nonce : Maybe(String),
  prevHash : String using "prev_hash",
  merkleTreeRoot : String using "merkle_tree_root",
  timestamp : Number,
  difficulty : Maybe(Number),
  kind : String,
  address : String,
  publicKey : Maybe(String) using "public_key",
  signature : Maybe(String),
  hash : Maybe(String)
}

record BlocksPageCount {
  blocksPageCount : Number using "blocks_page_count"
}
