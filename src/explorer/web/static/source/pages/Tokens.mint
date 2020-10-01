component Pages.Tokens {
  connect Stores.Tokens exposing { tokens }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h5 class="card-title">
            "Tokens"
          </h5>
        </div>

        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-striped table-hover">
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
