component Search {
  fun render : Html {
    <div class="card has-margin-top-15 has-margin-top-5-mobile">
      <header class="card-header">
        <p class="card-header-title">
          "Blockchain Explorer"
        </p>
      </header>

      <div class="card-content">
        <div class="content">
          <div class="field has-addons">
            <p class="control has-icons-left is-expanded">
              <input
                class="input is-large"
                type="text"
                placeholder="search by blocks, transactions, addresses, domains, tokens"/>

              <span class="icon is-medium is-left">
                <i
                  class="fas fa-search"
                  aria-hidden="true"/>
              </span>
            </p>

            <p class="control">
              <button
                type="submit"
                class="button is-primary is-large">

                "Search"

              </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  }
}
