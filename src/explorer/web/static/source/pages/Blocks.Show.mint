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
              <{ Number.toString(block.nonce) }>
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
              <{ DDate.formatFromTS(block.timestamp) }>
            </td>
          </tr>

          <tr>
            <th>
              "Difficulty"
            </th>

            <td>
              <{ Number.toString(block.difficulty) }>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  }
}
