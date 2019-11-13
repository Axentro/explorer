component Pages.Domains.Show {
  connect Stores.Domains exposing { domain }

  fun render : Html {
    <div class="container">
      <table class="table">
        <thead>
          <th colspan="2">
            <h1 class="title">
              "Domain"
            </h1>
          </th>
        </thead>

        <tbody>
          <tr>
            <th>
              "Name"
            </th>

            <td>
              <{ domain.name }>
            </td>
          </tr>

          <tr>
            <th>
              "Address"
            </th>

            <td>
              <{ domain.address }>
            </td>
          </tr>

          <tr>
            <th>
              "Time"
            </th>

            <td>
              <{ DDate.formatFromTSM(domain.timestamp) }>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  }
}
