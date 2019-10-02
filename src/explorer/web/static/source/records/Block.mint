record Block {
  index : Number,
  transactions : Array(Transaction),
  nonce : Number,
  prevHash : String using "prev_hash",
  merkleTreeRoot : String using "merkle_tree_root",
  timestamp : Number,
  difficulty : Number,
  publicKey : String using "public_key",
  signR : String using "sign_r",
  signS : String using "sign_s",
  hash : String
}
