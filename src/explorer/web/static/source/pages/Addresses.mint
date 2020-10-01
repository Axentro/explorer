component Pages.Addresses {
  connect Stores.Addresses exposing { addresses }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h5 class="card-title">
            "Addresses"
          </h5>
        </div>

        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-striped table-hover">
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
