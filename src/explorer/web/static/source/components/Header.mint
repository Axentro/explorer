component Header {
  fun render : Html {
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
      <a
        class="navbar-brand"
        href="/">

        <img
          src="/images/axentro-nav-brand.svg"
          width="112"
          height="28"
          class="d-inline-block align-top"
          alt="Axentro logo"
          loading="lazy"/>

      </a>

      <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation">

        <span class="navbar-toggler-icon"/>

      </button>

      <div
        class="collapse navbar-collapse"
        id="navbarSupportedContent">

        <ul class="navbar-nav mr-auto">
          <li class="nav-item">
            <a
              class="nav-link"
              href="/blocks">

              "Blocks"

            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link"
              href="/transactions">

              "Transactions"

            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link"
              href="/addresses">

              "Addresses"

            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link"
              href="/domains">

              "Domains"

            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link"
              href="/tokens">

              "Tokens"

            </a>
          </li>
        </ul>

        <Search/>

      </div>
    </nav>
  }
}
