component Pages.Blocks {
  connect Stores.Blocks exposing { blocks }

  fun render : Html {
    <div class="container is-fluid">
      <Search/>

      <div class="card has-margin-top-15 has-margin-top-5-mobile">
        <header class="card-header">
          <p class="card-header-title">
            "Blocks"
          </p>
        </header>

        <Paginate controller="blocks"/>

        <div class="card-content">
          <div class="content">
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
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
