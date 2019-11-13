component Pages.Domains {
  connect Stores.Domains exposing { domains }

  fun render : Html {
    <div class="container is-fluid">
      <Search/>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            "Domains"
          </p>
        </header>

        <div class="card-content">
          <div class="content">
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
              <thead>
                <{ Domain.renderHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Domain.renderHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Domain.renderLine, domains) }>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  }
}
