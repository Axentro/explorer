store Stores.Application {
  state page : Page = Page::Home

  fun setPage (page : Page) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }
}
