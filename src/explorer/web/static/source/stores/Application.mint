store Stores.Application {
  state page : Page = Page::Home
  state errorMsg : String = ""
  state successMsg : String = ""

  fun setPage (page : Page) : Promise(Never, Void) {
    sequence {
      Http.abortAll()
      next { page = page }
    }
  }

  fun setErrorMsg (msg : String) : Promise(Never, Void) {
    next { errorMsg = msg }
  }

  fun setSuccessMsg (msg : String) : Promise(Never, Void) {
    next { successMsg = msg }
  }
}
