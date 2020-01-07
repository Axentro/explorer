record TokenAmount {
  token : String,
  amount : Number
}

record Address {
  address : String,
  amount : Number,
  tokenAmounts : Array(TokenAmount) using "token_amounts",
  domains : Array(Domain),
  timestamp : Number
}
