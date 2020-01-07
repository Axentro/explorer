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
    parallel {
      Application.setPage(Page::Addresses)
      Stores.Addresses.getAddresses(1)
    }
  }

  /addresses/page/:page (page : Number) {
    parallel {
      Application.setPage(Page::Addresses)
      Stores.Addresses.getAddresses(page)
    }
  }

  /addresses/show/:address (address : String) {
    parallel {
      Application.setPage(Page::Addresses.Show)
      Stores.Addresses.getAddress(address)
    }
  }

  /blocks {
    parallel {
      Application.setPage(Page::Blocks)
      Stores.Blocks.getBlocks(1)
    }
  }

  /blocks/page/:page (page : Number) {
    parallel {
      Application.setPage(Page::Blocks)
      Stores.Blocks.getBlocks(page)
    }
  }

  /blocks/show/:index (index : Number) {
    parallel {
      Application.setPage(Page::Blocks.Show)
      Stores.Blocks.getBlock(index)
    }
  }

  /domains {
    parallel {
      Application.setPage(Page::Domains)
      Stores.Domains.getDomains(1)
    }
  }

  /domains/page/:page (page : Number) {
    parallel {
      Application.setPage(Page::Domains)
      Stores.Domains.getDomains(page)
    }
  }

  /domains/show/:name (name : String) {
    parallel {
      Application.setPage(Page::Domains.Show)
      Stores.Domains.getDomain(name)
    }
  }

  /tokens {
    parallel {
      Application.setPage(Page::Tokens)
      Stores.Tokens.getTokens(1)
    }
  }

  /tokens/page/:page (page : Number) {
    parallel {
      Application.setPage(Page::Tokens)
      Stores.Tokens.getTokens(page)
    }
  }

  /tokens/show/:name (name : String) {
    parallel {
      Application.setPage(Page::Tokens.Show)
      Stores.Tokens.getToken(name)
    }
  }

  /transactions {
    parallel {
      Application.setPage(Page::Transactions)
      Stores.Transactions.getTransactions(1)
    }
  }

  /transactions/page/:page (page : Number) {
    parallel {
      Application.setPage(Page::Transactions)
      Stores.Transactions.getTransactions(page)
    }
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
      Stores.Blocks.loadTop()
      Stores.Transactions.loadTop()
    }
  }
}
