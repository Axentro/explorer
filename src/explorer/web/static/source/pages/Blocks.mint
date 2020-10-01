component Pages.Blocks {
  connect Stores.Blocks exposing { blocks }

  fun render : Html {
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h5 class="card-title">
            "Blocks"
          </h5>
        </div>

        <Paginate controller="blocks"/>

        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-striped table-hover">
              <thead>
                <{ Block.renderHeaderFooterTable() }>
              </thead>

              <tfoot>
                <{ Block.renderHeaderFooterTable() }>
              </tfoot>

              <tbody>
                <{ Array.map(Block.renderLine, blocks) }>
              </tbody>
            </table>
          </div>
        </div>

        <Paginate controller="blocks"/>
      </div>
    </div>
  }
}
