component Pages.Transactions.Show {
  connect Stores.Transactions exposing { transaction }

  fun render : Html {
    <div class="container">
      <table class="table">
        <thead>
          <th colspan="2">
            <h1 class="title">
              "Transaction"
            </h1>
          </th>
        </thead>

        <tbody>
          <tr>
            <th>
              "Transaction ID"
            </th>

            <td>
              <{ transaction.id }>
            </td>
          </tr>

          <tr>
            <th>
              "Block index"
            </th>

            <td>
              <a href={"/blocks/show/" + Number.toString(Maybe.withDefault(0, transaction.blockIndex))}>
                <{ Number.toString(Maybe.withDefault(0, transaction.blockIndex)) }>
              </a>
            </td>
          </tr>

          <tr>
            <th>
              "Action"
            </th>

            <td>
              <{ transaction.action }>
            </td>
          </tr>

          <tr>
            <th>
              "Number of senders"
            </th>

            <td>
              <{ Number.toString(Array.size(transaction.senders)) }>
            </td>
          </tr>

          <tr>
            <th>
              "Number of recipients"
            </th>

            <td>
              <{ Number.toString(Array.size(transaction.recipients)) }>
            </td>
          </tr>

          <tr>
            <th>
              "Message"
            </th>

            <td>
              if ("0" == transaction.message) {
                "-"
              } else {
                transaction.message
              }
            </td>
          </tr>

          <tr>
            <th>
              "Token"
            </th>

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

          <tr>
            <th>
              "Previous hash"
            </th>

            <td>
              if ("0" == transaction.prevHash) {
                "-"
              } else {
                transaction.prevHash
              }
            </td>
          </tr>

          <tr>
            <th>
              "Time"
            </th>

            <td>
              <{ DDate.formatFromTSM(transaction.timestamp) }>
            </td>
          </tr>

          <tr>
            <th>
              "Scaled"
            </th>

            <td>
              if (transaction.scaled == 1) {
                "yes"
              } else {
                "no"
              }
            </td>
          </tr>
        </tbody>
      </table>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            <{ "Senders (" + Number.toString(Array.size(transaction.senders)) + ")" }>
          </p>
        </header>

        if (Array.size(transaction.senders) > 0) {
          <div class="card-content">
            <div class="content">
              <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                <thead>
                  <{ Transaction.renderSendersHeaderFooterTable() }>
                </thead>

                <tfoot>
                  <{ Transaction.renderSendersHeaderFooterTable() }>
                </tfoot>

                <tbody>
                  <{ Array.map(Transaction.renderSendersLine, transaction.senders) }>
                </tbody>
              </table>
            </div>
          </div>
        } else {
          <></>
        }
      </div>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            <{ "Recipients (" + Number.toString(Array.size(transaction.recipients)) + ")" }>
          </p>
        </header>

        if (Array.size(transaction.recipients) > 0) {
          <div class="card-content">
            <div class="content">
              <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                <thead>
                  <{ Transaction.renderRecipientsHeaderFooterTable() }>
                </thead>

                <tfoot>
                  <{ Transaction.renderRecipientsHeaderFooterTable() }>
                </tfoot>

                <tbody>
                  <{
                    Array.map(
                      Transaction.renderRecipientsLine,
                      transaction.recipients)
                  }>
                </tbody>
              </table>
            </div>
          </div>
        } else {
          <></>
        }
      </div>
    </div>
  }
}
