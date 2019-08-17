component Pages.Tokens {
  connect Stores.Tokens exposing { tokens }

  fun render : Html {
    <div class="container is-fluid">
      <Search/>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            "Tokens"
          </p>
        </header>

        <div class="card-content">
          <div class="content">
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
              <thead>
                <{ Token.renderHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Token.renderHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Token.renderLine, tokens) }>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}
