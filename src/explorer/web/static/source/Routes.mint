enum Page {
  Addresses
  Addresses.Show
  Blocks
  Blocks.Show
  Domains
  Domains.Show
  Home
  Tokens
  Tokens.Show
  Transactions
  Transactions.Show
}

routes {
  /addresses {
    Application.setPage(Page::Addresses)
  }

  /addresses/show/:name (name : String) {
    Application.setPage(Page::Addresses.Show)
  }

  /blocks {
    Application.setPage(Page::Blocks)
  }

  /blocks/show/:index (index : Number) {
    parallel {
      Application.setPage(Page::Blocks.Show)
      Stores.Blocks.getBlock(index)
    }
  }

  /domains {
    Application.setPage(Page::Domains)
  }

  /domains/show/:name (name : String) {
    Application.setPage(Page::Domains.Show)
  }

  /tokens {
    Application.setPage(Page::Tokens)
  }

  /tokens/show/:name (name : String) {
    Application.setPage(Page::Tokens.Show)
  }

  /transactions {
    Application.setPage(Page::Transactions)
  }

  /transactions/show/:txid (txid : String) {
    parallel {
      Application.setPage(Page::Transactions.Show)
      Stores.Transactions.getTransaction(txid)
    }
  }

  / {
    parallel {
      Application.setPage(Page::Home)
      Stores.Blocks.loadTop(Application.limitHomeItemList)
      Stores.Transactions.loadTop(Application.limitHomeItemList)
    }
  }
}
