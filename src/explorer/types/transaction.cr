module Explorer
  module Types
    alias Sender = NamedTuple(
      address: String,
      public_key: String,
      amount: Int64,
      fee: Int64,
      sign_r: String,
      sign_s: String,
    )

    alias Senders = Array(Sender)

    alias Recipient = NamedTuple(
      address: String,
      amount: Int64,
    )

    alias Recipients = Array(Recipient)

    alias Transactions = Array(Transaction)

    alias Transaction = NamedTuple(
      id: String,
      action: String,
      senders: Senders,
      recipients: Recipients,
      message: String,
      token: String,
      prev_hash: String,
      timestamp: Int64,
      scaled: Int32,
    )
  end
end
