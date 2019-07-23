component Header {
  fun render : Html {
    <>
      <nav
        class="navbar is-fxed-top is-dark"
        role="navigation"
        aria-label="main navigation">

        <div class="navbar-brand">
          <a
            class="navbar-item"
            href="/">

            <img
              src="/images/sushichain-nav-brand.svg"
              width="112"
              height="28"/>

          </a>

          <a
            role="button"
            class="navbar-burger burger"
            aria-label="menu"
            aria-expanded="false"
            data-target="navbarSushichainExplorer">

            <span aria-hidden="true"/>
            <span aria-hidden="true"/>
            <span aria-hidden="true"/>

          </a>
        </div>

        <div
          id="navbarSushichainExplorer"
          class="navbar-menu">

          <div class="navbar-start">
            <div class="navbar-item">
              <div class="field">
                <div class="control has-icons-left">
                  <input
                    id="input-search-form"
                    class="input"
                    type="text"
                    name="search"
                    placeholder="Search for blocks, transactions or addresses"/>

                  <span class="icon is-small is-left">
                    <i
                      class="fas fa-search"
                      aria-hidden="true"/>
                  </span>
                </div>
              </div>
            </div>
          </div>

          <div class="navbar-end">
            <a
              class="navbar-item"
              href="/blocks">

              "Blocks"

            </a>

            <a
              class="navbar-item"
              href="/transactions">

              "Transactions"

            </a>

            <a
              class="navbar-item"
              href="/addresses">

              "Addresses"

            </a>
          </div>

        </div>

      </nav>
    </>
  }
}
