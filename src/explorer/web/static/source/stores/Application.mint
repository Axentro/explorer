store Application {
  state limitHomeItemList : Number = 10
  state refreshHomePageInSecond : Number = 15
  state page : Page = Page::Home
  state anchor : Maybe(String) = Maybe.nothing()

  fun setPage (page : Page) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }

  fun setAnchor (anchor : String) : Promise(Never, Void) {
    next { anchor = Maybe.just(anchor) }
  }
}
