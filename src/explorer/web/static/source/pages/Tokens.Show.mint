component Pages.Tokens.Show {
  connect Stores.Tokens exposing { token }

  fun render : Html {
    <div class="container-fluid">
      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead>
            <th colspan="2">
              <h2>
                "Token"
              </h2>
            </th>
          </thead>

          <tbody>
            <tr>
              <th>
                "Name"
              </th>

              <td>
                <{ token.name }>
              </td>
            </tr>

            <tr>
              <th>
                "Time"
              </th>

              <td>
                <{ DDate.formatFromTSM(token.timestamp) }>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  }
}
