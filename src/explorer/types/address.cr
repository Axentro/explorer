module Explorer
  module Types
    alias TokenAmount = NamedTuple(
      token: String,
      amount: Int64)

    alias Address = NamedTuple(
      address: String,
      amount: Int64,
      token_amounts: Array(TokenAmount),
      timestamp: Int64,
    )
  end
end
