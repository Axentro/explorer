record Sender {
  address : String,
  publicKey : String using "public_key",
  amount : Number,
  fee : Number,
  signR : String using "sign_r",
  signS : String using "sign_s"
}

record Recipient {
  address : String,
  amount : Number
}

record Transaction {
  id : String,
  blockIndex : Number using "block_index",
  action : String,
  senders : Array(Sender),
  recipients : Array(Recipient),
  message : String,
  token : String,
  prevHash : String using "prev_hash",
  timestamp : Number,
  scaled : Number
}
