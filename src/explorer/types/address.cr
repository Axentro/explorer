module Explorer
  module Types
    alias Address = NamedTuple(
      address: String,
      token_amounts: Hash(String, Float64),
      timestamp: Int64,
    )
  end
end
