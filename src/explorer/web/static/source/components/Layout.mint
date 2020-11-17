component Layout {
  connect Stores.Application exposing { errorMsg, successMsg }
  property children : Array(Html) = []

  fun render : Html {
    <>
      <Header/>
      <{ UiHelper.errorAlert(errorMsg) }>
      <{ UiHelper.successAlert(successMsg) }>

      <{ children }>

      <Footer/>
    </>
  }
}
