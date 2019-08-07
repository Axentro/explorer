component Pages.Transactions {
  connect Stores.Transactions exposing { transactions }

  fun render : Html {
    <div class="container is-fluid">
      <Search/>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            "Transactions"
          </p>
        </header>

        <div class="card-content">
          <div class="content">
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
              <thead>
                <{ Transaction.renderHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Transaction.renderHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Transaction.renderTransactionLine, transactions) }>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}
