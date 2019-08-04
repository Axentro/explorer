component Pages.Home {
  connect Stores.Blocks exposing { blocks }
  connect Stores.Transactions exposing { transactions }

  fun renderBlockLine (block : Block) : Html {
    <tr>
      <td>
        <a href={"/blocks/show/" + Number.toString(block.index)}>
          <{ Number.toString(block.index) }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTS(block.timestamp) }>
      </td>

      <td>
        <{ Number.toString(Array.size(block.transactions)) }>
      </td>
    </tr>
  }

  fun renderTransactionLine (transaction : Transaction) : Html {
    <tr>
      <td>
        <a href={"/transactions/show/" + transaction.id}>
          <{ SString.substring(transaction.id, 0, 16) + "..." }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTS(transaction.timestamp) }>
      </td>

      <td>
        <{ transaction.action }>
      </td>

      <td>
        <{ transaction.token }>
      </td>
    </tr>
  }

  use Provider.TTick {
    ticks =
      () : Promise(Never, Void) {
        parallel {
          /* load blocks */
          Stores.Blocks.loadTop(Application.limitHomeItemList)

          /* load transactions */
          Stores.Transactions.loadTop(Application.limitHomeItemList)
        }
      }
  }

  fun render : Html {
    <div class="container is-fluid">
      <Search/>

      <div class="columns">
        <div class="column">
          <div class="card has-margin-top-15 has-margin-top-5-mobile">
            <header class="card-header">
              <p class="card-header-title">
                "Latest Blocks"
              </p>

              <p class="card-header-title">
                <a
                  class="button is-link is-medium"
                  href="/blocks"
                  aria-label="list of blocks">

                  "View all"

                </a>
              </p>
            </header>

            <div class="card-content">
              <div class="content">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                  <thead>
                    <tr>
                      <th>
                        "Index"
                      </th>

                      <th>
                        "Time"
                      </th>

                      <th>
                        "Number of tx"
                      </th>
                    </tr>
                  </thead>

                  <tfoot>
                    <tr>
                      <th>
                        "Index"
                      </th>

                      <th>
                        "Time"
                      </th>

                      <th>
                        "Number of tx"
                      </th>
                    </tr>
                  </tfoot>

                  <tbody>
                    <{ Array.map(renderBlockLine, blocks) }>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div class="column">
          <div class="card has-margin-top-15 has-margin-top-5-mobile">
            <header class="card-header">
              <p class="card-header-title">
                "Latest Transactions"
              </p>

              <p class="card-header-title">
                <a
                  class="button is-link is-flex is-medium is-pulled-left"
                  href="/transactions"
                  aria-label="list of transactions">

                  "View all"

                </a>
              </p>
            </header>

            <div class="card-content">
              <div class="content">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                  <thead>
                    <tr>
                      <th>
                        "Transaction ID"
                      </th>

                      <th>
                        "Time"
                      </th>

                      <th>
                        "Action"
                      </th>

                      <th>
                        "Token"
                      </th>
                    </tr>
                  </thead>

                  <tfoot>
                    <tr>
                      <th>
                        "Transaction ID"
                      </th>

                      <th>
                        "Time"
                      </th>

                      <th>
                        "Action"
                      </th>

                      <th>
                        "Token"
                      </th>
                    </tr>
                  </tfoot>

                  <tbody>
                    <{ Array.map(renderTransactionLine, transactions) }>
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
