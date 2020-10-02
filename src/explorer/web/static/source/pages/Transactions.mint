component Pages.Transactions {
  connect Stores.Transactions exposing { transactions, currentPage, pageCount }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="mb-4 card-header">
          <h5 class="card-title">
            "Transactions"
          </h5>
        </div>

        <Paginate
          controller="transactions"
          currentPage={currentPage}
          maxPage={pageCount}/>

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

        <Paginate
          controller="transactions"
          currentPage={currentPage}
          maxPage={pageCount}/>
      </div>
    </div>
  }
}
