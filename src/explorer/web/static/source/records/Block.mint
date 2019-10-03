record Block {
  index : Number,
  transactions : Array(Transaction),
  nonce : Maybe(Number),
  prevHash : String using "prev_hash",
  merkleTreeRoot : String using "merkle_tree_root",
  timestamp : Number,
  difficulty : Maybe(Number),
  kind : String,
  address : String,
  publicKey : Maybe(String) using "public_key",
  signR : Maybe(String) using "sign_r",
  signS : Maybe(String) using "sign_s",
  hash : Maybe(String)
}
