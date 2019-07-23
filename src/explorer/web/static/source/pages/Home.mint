component Home {
  fun render : Html {
    <>
      <div class="container is-fluid">
        <div class="card has-margin-top-15 has-margin-top-5-mobile">
          <header class="card-header">
            <p class="card-header-title">
              "Blockchain Explorer"
            </p>
          </header>

          <div class="card-content">
            <div class="content">
              <p class="control has-icons-left">
                <input
                  class="input is-large"
                  type="text"
                  placeholder="search"/>

                <span class="icon is-medium is-left">
                  <i
                    class="fas fa-search"
                    aria-hidden="true"/>
                </span>
              </p>
            </div>
          </div>
        </div>

        <div class="card has-margin-top-15 has-margin-top-5-mobile">
          <header class="card-header">
            <p class="card-header-title">
              "Market"
            </p>
          </header>

          <div class="card-content">
            <div class="content">
              <p>
                "data..."
              </p>
            </div>
          </div>
        </div>

        <div class="columns">
          <div class="column">
            <div class="card has-margin-top-15 has-margin-top-5-mobile">
              <header class="card-header">
                <p class="card-header-title">
                  "Explore Blocks"
                </p>
              </header>

              <div class="card-content">
                <div class="content">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>
                          "Index"
                        </th>

                        <th>
                          "Time"
                        </th>

                        <th>
                          "Transactions"
                        </th>

                        <th>
                          "Address"
                        </th>

                        <th>
                          "Size"
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
                          "Transactions"
                        </th>

                        <th>
                          "Address"
                        </th>

                        <th>
                          "Size"
                        </th>
                      </tr>
                    </tfoot>

                    <tbody>
                      <tr>
                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>
                      </tr>
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
                  "Explore Transactions"
                </p>
              </header>

              <div class="card-content">
                <div class="content">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>
                          "Transaction ID"
                        </th>

                        <th>
                          "Type"
                        </th>

                        <th>
                          "Time"
                        </th>

                        <th>
                          "Length"
                        </th>
                      </tr>
                    </thead>

                    <tfoot>
                      <tr>
                        <th>
                          "Transaction ID"
                        </th>

                        <th>
                          "Type"
                        </th>

                        <th>
                          "Time"
                        </th>

                        <th>
                          "Length"
                        </th>
                      </tr>
                    </tfoot>

                    <tbody>
                      <tr>
                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>

                        <td>
                          "..."
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  }
}
