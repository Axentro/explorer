component Pages.Transactions.Show {
  connect Stores.Transactions exposing { transaction }

  fun render : Html {
    <div class="container-fluid">
      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead>
            <th colspan="2">
              <h2>
                "Transaction"
              </h2>
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
      </div>

      <div class="row">
        if (Array.size(transaction.senders) > 0) {
          <div class="col">
            <div class="card">
              <div class="card-header">
                <h5 class="card-title">
                  <{ "Senders (" + Number.toString(Array.size(transaction.senders)) + ")" }>
                </h5>
              </div>

              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-striped table-hover">
                    <thead>
                      <{ Transaction.renderSendersHeaderFooterTable() }>
                    </thead>

                    <tfoot>
                      <{ Transaction.renderSendersHeaderFooterTable() }>
                    </tfoot>

                    <tbody>
                      if (Array.size(transaction.recipients) == 0) {
                        Array.map(Transaction.renderSendersLine, transaction.senders)
                      } else {
                        Array.map(Transaction.renderSendersLineShrink, transaction.senders)
                      }
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        }

        if (Array.size(transaction.recipients) > 0) {
          <div class="col">
            <div class="card">
              <div class="card-header">
                <h5 class="card-title">
                  <{ "Recipients (" + Number.toString(Array.size(transaction.recipients)) + ")" }>
                </h5>
              </div>

              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-striped table-hover">
                    <thead>
                      <{ Transaction.renderRecipientsHeaderFooterTable() }>
                    </thead>

                    <tfoot>
                      <{ Transaction.renderRecipientsHeaderFooterTable() }>
                    </tfoot>

                    <tbody>
                      if (Array.size(transaction.senders) == 0) {
                        Array.map(
                          Transaction.renderRecipientsLine,
                          transaction.recipients)
                      } else {
                        Array.map(
                          Transaction.renderRecipientsLineShrink,
                          transaction.recipients)
                      }
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        }
      </div>
    </div>
  }
}
