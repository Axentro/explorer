component Pages.Tokens {
  connect Stores.Tokens exposing { tokens, currentPage, pageCount }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="mb-4 card-header">
          <h5 class="card-title">
            "Tokens"
          </h5>
        </div>

        <Paginate
          controller="tokens"
          currentPage={currentPage}
          maxPage={pageCount}/>

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

        <Paginate
          controller="tokens"
          currentPage={currentPage}
          maxPage={pageCount}/>
      </div>
    </div>
  }
}
