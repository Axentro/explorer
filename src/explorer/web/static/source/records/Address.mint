record Address {
  address : String,
  tokenAmounts : Map(String, Number) using "token_amounts",
  domains : Array(Domain),
  timestamp : Number
}

record AddressesPageCount {
  addressesPageCount : Number using "addresses_page_count"
}
