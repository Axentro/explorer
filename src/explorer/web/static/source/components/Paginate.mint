component Paginate {
  property page : Number = 1
  property totalPage : Number = 5
  property controller : String = ""

  fun render : Html {
    if (totalPage == 1) {
      <></>
    } else {
      <nav
        class="mt-1 pagination is-small is-centered"
        role="navigation"
        aria-label="pagination">

        if (totalPage > 1) {
          <>
            if (page > 1) {
              <a
                class="pagination-previous"
                href={"/" + controller + "/page/" + Number.toString(page - 1)}>

                "Previous"

              </a>
            }

            if (page < totalPage) {
              <a
                class="pagination-next"
                href={"/" + controller + "/page/" + Number.toString(page + 1)}>

                "Next"

              </a>
            }
          </>
        }

        <ul class="pagination-list">
          <li>
            <a
              class="pagination-link is-current"
              aria-label={"Page " + Number.toString(page)}
              aria-current="page"
              href={"/" + controller + "/page/" + Number.toString(page)}>

              <{ Number.toString(page) }>

            </a>
          </li>
        </ul>

      </nav>
    }
  }
}
