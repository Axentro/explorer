component Main {
  connect Application exposing { page }

  fun render : Html {
    <Layout>
      case (page) {
        Page::Home => <Pages.Home/>
        Page::Addresses => <Pages.Addresses/>
        Page::Addresses.Show => <Pages.Addresses.Show/>
        Page::Blocks => <Pages.Blocks/>
        Page::Blocks.Show => <Pages.Blocks.Show/>
        Page::Domains => <Pages.Domains/>
        Page::Domains.Show => <Pages.Domains.Show/>
        Page::Tokens => <Pages.Tokens/>
        Page::Tokens.Show => <Pages.Tokens.Show/>
        Page::Transactions => <Pages.Transactions/>
        Page::Transactions.Show => <Pages.Transactions.Show/>
      }
    </Layout>
  }
}
