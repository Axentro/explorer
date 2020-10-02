component Pages.Domains {
  connect Stores.Domains exposing { domains, currentPage, pageCount }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="mb-4 card-header">
          <h5 class="card-title">
            "Domains"
          </h5>
        </div>

        <Paginate
          controller="domains"
          currentPage={currentPage}
          maxPage={pageCount}/>

        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-striped table-hover">
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

        <Paginate
          controller="domains"
          currentPage={currentPage}
          maxPage={pageCount}/>
      </div>
    </div>
  }
}
