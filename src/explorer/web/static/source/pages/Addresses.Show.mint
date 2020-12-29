component Pages.Addresses.Show {
  connect Stores.Addresses exposing { address }

  fun render : Html {
    <div class="container-fluid">
      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead>
            <th colspan="2">
              <h2>
                "Address"
              </h2>
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
                "AXNT amount"
              </th>

              <td>
                <{
                  Number.toString(
                    (address.tokenAmounts
                    |> Map.getWithDefault("AXNT", 0.0)))
                }>
              </td>
            </tr>

            <tr>
              <th>
                "Number of tokens"
              </th>

              <td>
                <{
                  Number.toString(
                    (address.tokenAmounts
                    |> Map.size()))
                }>
              </td>
            </tr>

            <tr>
              <th>
                "Number of domains"
              </th>

              <td>
                <{ Number.toString(Array.size(address.domains)) }>
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
      </div>

      <div class="row">
        if ((address.tokenAmounts
            |> Map.size()) > 0) {
          <div class="col">
            <div class="card">
              <div class="card-header">
                <h5 class="card-title">
                  <{
                    "Tokens (" + Number.toString(
                      (address.tokenAmounts
                      |> Map.size())) + ")"
                  }>
                </h5>
              </div>

              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-striped table-hover">
                    <thead>
                      <{ AddressToken.renderHeaderFooterTable() }>
                    </thead>

                    <tfoot>
                      <{ AddressToken.renderHeaderFooterTable() }>
                    </tfoot>

                    <tbody>
                      for (token, amount of address.tokenAmounts) {
                        AddressToken.renderLine(token, amount)
                      }
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        }

        if (Array.size(address.domains) > 0) {
          <div class="col">
            <div class="card">
              <div class="card-header">
                <h5 class="card-title">
                  <{ "Domains (" + Number.toString(Array.size(address.domains)) + ")" }>
                </h5>
              </div>

              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-striped table-hover">
                    <thead>
                      <{ Domain.renderInAddressHeaderFooterTable() }>
                    </thead>

                    <tfoot>
                      <{ Domain.renderInAddressHeaderFooterTable() }>
                    </tfoot>

                    <tbody>
                      <{ Array.map(Domain.renderInAddressLine, address.domains) }>
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
