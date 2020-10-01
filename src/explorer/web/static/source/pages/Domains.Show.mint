component Pages.Domains.Show {
  connect Stores.Domains exposing { domain }

  fun render : Html {
    <div class="container-fluid">
      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead>
            <th colspan="2">
              <h2>"Domain"</h2>
            </th>
          </thead>

          <tbody>
            <tr>
              <th>"Name"</th>

              <td>
                <{ domain.name }>
              </td>
            </tr>

            <tr>
              <th>"Address"</th>

              <td>
                <{ domain.address }>
              </td>
            </tr>

            <tr>
              <th>"Time"</th>

              <td>
                <{ DDate.formatFromTSM(domain.timestamp) }>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  }
}
