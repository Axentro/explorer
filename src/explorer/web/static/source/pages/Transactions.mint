component Pages.Transactions {
  connect Stores.Transactions exposing { transactions }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h5 class="card-title">
            "Transactions"
          </h5>
        </div>

        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-striped table-hover">
              <thead>
                <{ Transaction.renderHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Transaction.renderHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Transaction.renderLine, transactions) }>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}
