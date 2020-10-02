component Pages.Addresses {
  connect Stores.Addresses exposing { addresses, currentPage, pageCount }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="mb-4 card-header">
          <h5 class="card-title">
            "Addresses"
          </h5>
        </div>

        <Paginate
          controller="addresses"
          currentPage={currentPage}
          maxPage={pageCount}/>

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

        <Paginate
          controller="addresses"
          currentPage={currentPage}
          maxPage={pageCount}/>
      </div>
    </div>
  }
}
