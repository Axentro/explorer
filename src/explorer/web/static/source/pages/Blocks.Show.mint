component Pages.Blocks.Show {
  connect Stores.Blocks exposing { block }

  fun render : Html {
    <div class="container-fluid">
      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead>
            <th colspan="2">
              <h2>
                "Block"
              </h2>
            </th>
          </thead>

          <tbody>
            <tr>
              <th>
                "Block height"
              </th>

              <td>
                if (block.index % 2 == 0) {
                  <i
                    class="fas fa-hourglass"
                    title="slow"/>
                } else {
                  <i
                    class="fas fa-bolt"
                    title="fast"/>
                }

                " - "
                <{ Number.toString(block.index) }>
              </td>
            </tr>

            <tr>
              <th>
                "Address"
              </th>

              <td>
                <a
                  href={"/addresses/show/" + block.address}
                  title={block.address}>

                  <{ block.address }>

                </a>
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

            if (block.index % 2 == 0) {
              <tr>
                <th>
                  "Nonce"
                </th>

                <td>
                  <{ Maybe.withDefault("0", block.nonce) }>
                </td>
              </tr>
            }

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
      </div>

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
