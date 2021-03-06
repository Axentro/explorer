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
      scaled = 0,
      kind = ""
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
        if (Maybe.withDefault(0, transaction.blockIndex) % 2 == 0) {
          <i
            class="fas fa-hourglass"
            title="slow"/>
        } else {
          <i
            class="fas fa-bolt"
            title="fast"/>
        }

        " - "

        <a href={"/blocks/show/" + Number.toString(Maybe.withDefault(0, transaction.blockIndex))}>
          <{ Number.toString(Maybe.withDefault(0, transaction.blockIndex)) }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(transaction.timestamp) }>
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
            "badge " + if (transaction.token == "AXNT") {
              "badge-info"
            } else {
              "badge-light"
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
        <a
          href={"/transactions/show/" + transaction.id}
          title={transaction.id}>

          <{ SString.substring(transaction.id, 0, 16) + "..." }>

        </a>
      </td>

      <td>
        if (Maybe.withDefault(0, transaction.blockIndex) % 2 == 0) {
          <i
            class="fas fa-hourglass"
            title="slow"/>
        } else {
          <i
            class="fas fa-bolt"
            title="fast"/>
        }

        " - "

        <a href={"/blocks/show/" + Number.toString(Maybe.withDefault(0, transaction.blockIndex))}>
          <{ Number.toString(Maybe.withDefault(0, transaction.blockIndex)) }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(transaction.timestamp) }>
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
            "badge " + if (transaction.token == "AXNT") {
              "badge-info"
            } else {
              "badge-light"
            }
          }>

          <{ transaction.token }>

        </span>
      </td>
    </tr>
  }

  fun renderInBlockHeaderFooterTable : Html {
    <tr>
      <th>
        "Transaction ID"
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

  fun renderInBlockLine (transaction : Transaction) : Html {
    <tr>
      <td>
        <a href={"/transactions/show/" + transaction.id}>
          <{ transaction.id }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(transaction.timestamp) }>
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
            "badge " + if (transaction.token == "AXNT") {
              "badge-info"
            } else {
              "badge-light"
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
        "Fee "

        <span class="badge badge-info">
          "AXNT"
        </span>
      </th>
    </tr>
  }

  fun renderSendersLine (sender : Sender) : Html {
    <tr>
      <td>
        <a
          href={"/addresses/show/" + sender.address}
          title={sender.address}>

          <{ sender.address }>

        </a>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(sender.amount)) }>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(sender.fee)) }>
      </td>
    </tr>
  }

  fun renderSendersLineShrink (sender : Sender) : Html {
    <tr>
      <td>
        <a
          href={"/addresses/show/" + sender.address}
          title={sender.address}>

          <{ SString.substring(sender.address, 0, 16) + "..." }>

        </a>
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
        <a
          href={"/addresses/show/" + recipient.address}
          title={recipient.address}>

          <{ recipient.address }>

        </a>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(recipient.amount)) }>
      </td>
    </tr>
  }

  fun renderRecipientsLineShrink (recipient : Recipient) : Html {
    <tr>
      <td>
        <a
          href={"/addresses/show/" + recipient.address}
          title={recipient.address}>

          <{ SString.substring(recipient.address, 0, 16) + "..." }>

        </a>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(recipient.amount)) }>
      </td>
    </tr>
  }
}
