component Pages.Tokens.Show {
  connect Stores.Tokens exposing { token }

  fun render : Html {
    <div class="container">
      <table class="table">
        <thead>
          <th colspan="2">
            <h1 class="title">
              "Token"
            </h1>
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
              <{ DDate.formatFromTS(token.timestamp) }>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  }
}
