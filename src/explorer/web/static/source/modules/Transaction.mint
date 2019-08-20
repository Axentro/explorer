module Transaction {
  fun empty : Transaction {
    {
      id = "",
      blockIndex = Maybe.nothing(),
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

  fun renderHeaderFooterTable : Html {
    <tr>
      <th>
        "Transaction ID"
      </th>

      <th>
        "Block index"
      </th>

      <th>
        "Time"
      </th>

      <th>
        "Action"
      </th>

      <th>
        "Senders"
      </th>

      <th>
        "Recipients"
      </th>

      <th>
        "Token"
      </th>
    </tr>
  }

  fun renderLine (transaction : Transaction) : Html {
    <tr>
      <td>
        <a href={"/transactions/show/" + transaction.id}>
          <{ transaction.id }>
        </a>
      </td>

      <td>
        <a href={"/blocks/show/" + Number.toString(Maybe.withDefault(0, transaction.blockIndex))}>
          <{ Number.toString(Maybe.withDefault(0, transaction.blockIndex)) }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTS(transaction.timestamp) }>
      </td>

      <td>
        <{ transaction.action }>
      </td>

      <td>
        <{ Number.toString(Array.size(transaction.senders)) }>
      </td>

      <td>
        <{ Number.toString(Array.size(transaction.recipients)) }>
      </td>

      <td>
        <span
          class={
            "tag " + if (transaction.token == "SUSHI") {
              "is-info"
            } else {
              "is-light"
            }
          }>

          <{ transaction.token }>

        </span>
      </td>
    </tr>
  }

  fun renderLineShrink (transaction : Transaction) : Html {
    <tr>
      <td>
        <a href={"/transactions/show/" + transaction.id}>
          <{ SString.substring(transaction.id, 0, 16) + "..." }>
        </a>
      </td>

      <td>
        <a href={"/blocks/show/" + Number.toString(Maybe.withDefault(0, transaction.blockIndex))}>
          <{ Number.toString(Maybe.withDefault(0, transaction.blockIndex)) }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTS(transaction.timestamp) }>
      </td>

      <td>
        <{ transaction.action }>
      </td>

      <td>
        <{ Number.toString(Array.size(transaction.senders)) }>
      </td>

      <td>
        <{ Number.toString(Array.size(transaction.recipients)) }>
      </td>

      <td>
        <span
          class={
            "tag " + if (transaction.token == "SUSHI") {
              "is-info"
            } else {
              "is-light"
            }
          }>

          <{ transaction.token }>

        </span>
      </td>
    </tr>
  }

  fun renderSendersHeaderFooterTable : Html {
    <tr>
      <th>
        "Address"
      </th>

      <th>
        "Amount"
      </th>

      <th>
        "Fee"
      </th>
    </tr>
  }

  fun renderSendersLine (sender : Sender) : Html {
    <tr>
      <td>
        <{ sender.address }>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(sender.amount)) }>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(sender.fee)) }>
      </td>
    </tr>
  }

  fun renderRecipientsHeaderFooterTable : Html {
    <tr>
      <th>
        "Address"
      </th>

      <th>
        "Amount"
      </th>
    </tr>
  }

  fun renderRecipientsLine (recipient : Recipient) : Html {
    <tr>
      <td>
        <{ recipient.address }>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(recipient.amount)) }>
      </td>
    </tr>
  }
}
