component Search {
  fun render : Html {
    <form class="form-inline my-2 my-lg-0">
      <input
        class="form-control mr-sm-2"
        type="search"
        placeholder="search by address, transaction, block, domain, token"
        aria-label="Search"/>

      <button
        class="btn btn-outline-light my-2 my-sm-0"
        type="submit">

        "Search"

      </button>
    </form>
  }
}
