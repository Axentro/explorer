component Pages.Home {
  connect Stores.Blocks exposing { blocks }
  connect Stores.Transactions exposing { transactions }

  use Provider.TTick {
    ticks =
      () : Promise(Never, Void) {
        parallel {
          Stores.Blocks.loadTop(-1)
          Stores.Transactions.loadTop(-1)
        }
      }
  }

  fun render : Html {
    <div class="container-fluid">
      <div class="row">
        <div class="col">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title">
                "Latest Blocks"
              </h5>

              <h6 class="card-title">
                <a
                  class="btn btn-primary"
                  href="/blocks"
                  aria-label="list of blocks">

                  "View all"

                </a>
              </h6>
            </div>

            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-striped table-hover">
                  <thead>
                    <{ Block.renderHeaderFooterTable() }>
                  </thead>

                  <tfoot>
                    <{ Block.renderHeaderFooterTable() }>
                  </tfoot>

                  <tbody>
                    <{ Array.map(Block.renderLine, blocks) }>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div class="col">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title">
                "Latest Transactions"
              </h5>

              <h6 class="card-title">
                <a
                  class="btn btn-primary"
                  href="/transactions"
                  aria-label="list of transactions">

                  "View all"

                </a>
              </h6>
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
                    <{ Array.map(Transaction.renderLineShrink, transactions) }>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  }
}
