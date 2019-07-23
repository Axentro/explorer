component Layout {
  property children : Array(Html) = []

  fun render : Html {
    <>
      <Header/>

      <{ children }>

      <Footer/>
    </>
  }
}
