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
  action : String,
  senders : Array(Sender),
  recipients : Array(Recipient),
  message : String,
  token : String,
  prevHash : String using "prev_hash",
  timestamp : Number,
  scaled : Number
}

module Transaction {
  fun empty : Transaction {
    {
      id = "",
      action = "",
      senders = [],
      recipients = [],
      message = "",
      token = "",
      prevHash = "",
      timestamp = 0,
      scaled = 0
    }
  }

  fun decode (object : Object) : Result(Object.Error, Transaction) {
    decode object as Transaction
  }
}
