record Ui.Page {
  name : String,
  content : Html
}

component Main {
  connect Application exposing { page }

  get pageData : Array(Ui.Page) {
    [
      {
        name = "home",
        content =
          <Layout>
            <Home/>
          </Layout>
      },
      {
        name = "blocks",
        content =
          <Layout>
            <Blocks/>
          </Layout>
      },
      {
        name = "transactions",
        content =
          <Layout>
            <Transactions/>
          </Layout>
      },
      {
        name = "addresses",
        content =
          <Layout>
            <Addresses/>
          </Layout>
      }
    ]
  }

  fun render : Html {
    content
  } where {
    content =
      pageData
      |> Array.find((item : Ui.Page) : Bool { item.name == page })
      |> Maybe.map((item : Ui.Page) : Html { item.content })
      |> Maybe.withDefault(<></>)
  }
}
