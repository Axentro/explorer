component Pages.Addresses.Show {
  connect Stores.Addresses exposing { address }

  fun render : Html {
    <div class="container">
      <table class="table">
        <thead>
          <th colspan="2">
            <h1 class="title">
              "Address"
            </h1>
          </th>
        </thead>

        <tbody>
          <tr>
            <th>
              "Address"
            </th>

            <td>
              <{ address.address }>
            </td>
          </tr>

          <tr>
            <th>
              "SUSHI amount"
            </th>

            <td>
              <{ NNumber.toScale8(Number.toString(address.amount)) }>
            </td>
          </tr>

          <tr>
            <th>
              "Number of tokens"
            </th>

            <td>
              <{ Number.toString(Array.size(address.tokenAmounts)) }>
            </td>
          </tr>

          <tr>
            <th>
              "Time"
            </th>

            <td>
              <{ DDate.formatFromTSM(address.timestamp) }>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            <{ "Tokens (" + Number.toString(Array.size(address.tokenAmounts)) + ")" }>
          </p>
        </header>

        if (Array.size(address.tokenAmounts) > 0) {
          <div class="card-content">
            <div class="content">
              <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                <thead>
                  <{ TokenAmount.renderHeaderFooterTable() }>
                </thead>

                <tfoot>
                  <{ TokenAmount.renderHeaderFooterTable() }>
                </tfoot>

                <tbody>
                  <{ Array.map(TokenAmount.renderLine, address.tokenAmounts) }>
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
