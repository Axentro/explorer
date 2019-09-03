component Pages.Addresses {
  connect Stores.Addresses exposing { addresses }

  fun render : Html {
    <div class="container is-fluid">
      <Search/>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            "Addresses"
          </p>
        </header>

        <div class="card-content">
          <div class="content">
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
              <thead>
                <{ Address.renderHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Address.renderHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Address.renderLine, addresses) }>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}
