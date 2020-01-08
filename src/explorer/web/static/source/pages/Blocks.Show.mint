component Pages.Blocks.Show {
  connect Stores.Blocks exposing { block }

  fun render : Html {
    <div class="container">
      <table class="table">
        <thead>
          <th colspan="2">
            <h1 class="title">
              "Block"
            </h1>
          </th>
        </thead>

        <tbody>
          <tr>
            <th>
              "Block height"
            </th>

            <td>
              <span class="icon is-small is-left">
                <i
                  class={
                    "fas " + if (block.index % 2 == 0) {
                      "fa-building"
                    } else {
                      "fa-bolt"
                    }
                  }
                  aria-hidden="true"/>
              </span>

              <{ Number.toString(block.index) }>
            </td>
          </tr>

          <tr>
            <th>
              "Number of transations"
            </th>

            <td>
              <{ Number.toString(Array.size(block.transactions)) }>
            </td>
          </tr>

          <tr>
            <th>
              "Nonce"
            </th>

            <td>
              <{ Number.toString(Maybe.withDefault(0, block.nonce)) }>
            </td>
          </tr>

          <tr>
            <th>
              "Previous hash"
            </th>

            <td>
              <{ block.prevHash }>
            </td>
          </tr>

          <tr>
            <th>
              "Merkle tree root"
            </th>

            <td>
              <{ block.merkleTreeRoot }>
            </td>
          </tr>

          <tr>
            <th>
              "Time"
            </th>

            <td>
              <{ DDate.formatFromTSM(block.timestamp) }>
            </td>
          </tr>

          <tr>
            <th>
              "Difficulty"
            </th>

            <td>
              <{ Number.toString(Maybe.withDefault(0, block.difficulty)) }>
            </td>
          </tr>
        </tbody>
      </table>

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
                <{ Transaction.renderInBlockHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Transaction.renderInBlockHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Transaction.renderInBlockLine, block.transactions) }>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}
