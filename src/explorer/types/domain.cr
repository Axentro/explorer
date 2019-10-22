module Explorer
  module Types
    alias Domain = NamedTuple(
      name: String,
      address: String,
      timestamp: Int64,
    )
  end
end
