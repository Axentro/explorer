component Paginate {
  property currentPage : Number = 1
  property maxPage : Number = 1
  property controller : String = "blocks"

  fun render : Html {
    if (maxPage == 1) {
      <></>
    } else {
      <nav aria-label="pagination">
        <ul class="pagination justify-content-center">
          if (maxPage > 1) {
            <>
              <li
                class={
                  if (currentPage == 1) {
                    "page-item disabled"
                  } else {
                    "page-item"
                  }
                }>

                <a
                  class="page-link"
                  href={"/" + controller + "/page/1"}>

                  "First"

                </a>

              </li>

              <li
                class={
                  if (currentPage == 1) {
                    "page-item disabled"
                  } else {
                    "page-item"
                  }
                }>

                <a
                  class="page-link"
                  href={"/" + controller + "/page/" + Number.toString(currentPage - 1)}>

                  <i class="fas fa-chevron-left"/>

                </a>

              </li>

              <li class="page-item active">
                <a
                  class="page-link"
                  aria-label={"Page " + Number.toString(currentPage)}
                  aria-current="page"
                  href={"/" + controller + "/page/" + Number.toString(currentPage)}>

                  <{ Number.toString(currentPage) + " of " + Number.toString(maxPage) }>

                </a>
              </li>

              <li
                class={
                  if (currentPage == maxPage) {
                    "page-item disabled"
                  } else {
                    "page-item"
                  }
                }>

                <a
                  class="page-link"
                  href={"/" + controller + "/page/" + Number.toString(currentPage + 1)}>

                  <i class="fas fa-chevron-right"/>

                </a>

              </li>

              <li
                class={
                  if (currentPage == maxPage) {
                    "page-item disabled"
                  } else {
                    "page-item"
                  }
                }>

                <a
                  class="page-link"
                  href={"/" + controller + "/page/" + Number.toString(maxPage)}>

                  "Last"

                </a>

              </li>
            </>
          }
        </ul>
      </nav>
    }
  }
}
