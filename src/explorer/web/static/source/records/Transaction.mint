record Senders {
  address : String,
  publicKey : String using "public_key",
  amount : Number,
  fee : Number,
  signR : String using "sign_r",
  signS : String using "sign_s"
}

record Recipients {
  address : String,
  amount : Number
}

record Transaction {
  id : String,
  action : String,
  senders : Array(Senders),
  recipients : Array(Recipients),
  message : String,
  token : String,
  prevHash : String using "prev_hash",
  timestamp : Number,
  scaled : Number
}
