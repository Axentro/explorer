component Header {
  fun render : Html {
    <nav
      class="navbar is-fxed-top is-dark"
      role="navigation"
      aria-label="main navigation">

      <div class="navbar-brand">
        <a
          class="navbar-item"
          href="/">

          <img
            src="/images/axentro-nav-brand.svg"
            width="112"
            height="28"/>

        </a>

        <a
          role="button"
          class="navbar-burger burger"
          aria-label="menu"
          aria-expanded="false"
          data-target="navbarAxentroExplorer">

          <span aria-hidden="true"/>
          <span aria-hidden="true"/>
          <span aria-hidden="true"/>

        </a>
      </div>

      <div
        id="navbarAxentroExplorer"
        class="navbar-menu">

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

          <a
            class="navbar-item"
            href="/domains">

            "Domains"

          </a>

          <a
            class="navbar-item"
            href="/tokens">

            "Tokens"

          </a>
        </div>

      </div>

    </nav>
  }
}
