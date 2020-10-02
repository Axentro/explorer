record Sender {
  address : String,
  publicKey : String using "public_key",
  amount : Number,
  fee : Number,
  signature : String
}

record Recipient {
  address : String,
  amount : Number
}

record Transaction {
  id : String,
  blockIndex : Maybe(Number) using "block_index",
  action : String,
  senders : Array(Sender),
  recipients : Array(Recipient),
  message : String,
  token : String,
  prevHash : String using "prev_hash",
  timestamp : Number,
  scaled : Number,
  kind : String
}

record TransactionsPageCount {
  transactionsPageCount : Number using "transactions_page_count"
}
