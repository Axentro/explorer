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
              <{ transaction.message }>
            </td>
          </tr>

          <tr>
            <th>
              "Token"
            </th>

            <td>
              <{ transaction.token }>
            </td>
          </tr>

          <tr>
            <th>
              "Previous hash"
            </th>

            <td>
              <{ transaction.prevHash }>
            </td>
          </tr>

          <tr>
            <th>
              "Time"
            </th>

            <td>
              <{ DDate.formatFromTS(transaction.timestamp) }>
            </td>
          </tr>

          <tr>
            <th>
              "Scaled"
            </th>

            <td>
              <{ Number.toString(transaction.scaled) }>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  }
}
