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
      Stores.Application.setPage(Page::Addresses)
      Stores.Addresses.getAddresses(1)
      Stores.Addresses.setCurrentPage(1)
      Stores.Addresses.getPageCount()
    }
  }

  /addresses/page/:page (page : Number) {
    parallel {
      Stores.Application.setPage(Page::Addresses)
      Stores.Addresses.getAddresses(page)
      Stores.Addresses.setCurrentPage(page)
      Stores.Addresses.getPageCount()
    }
  }

  /addresses/show/:address (address : String) {
    parallel {
      Stores.Application.setPage(Page::Addresses.Show)
      Stores.Addresses.getAddress(address)
    }
  }

  /blocks {
    parallel {
      Stores.Application.setPage(Page::Blocks)
      Stores.Blocks.getBlocks(1)
      Stores.Blocks.setCurrentPage(1)
      Stores.Blocks.getPageCount()
    }
  }

  /blocks/page/:page (page : Number) {
    parallel {
      Stores.Application.setPage(Page::Blocks)
      Stores.Blocks.getBlocks(page)
      Stores.Blocks.setCurrentPage(page)
      Stores.Blocks.getPageCount()
    }
  }

  /blocks/show/:index (index : Number) {
    parallel {
      Stores.Application.setPage(Page::Blocks.Show)
      Stores.Blocks.getBlock(index)
    }
  }

  /domains {
    parallel {
      Stores.Application.setPage(Page::Domains)
      Stores.Domains.getDomains(1)
      Stores.Domains.setCurrentPage(1)
      Stores.Domains.getPageCount()
    }
  }

  /domains/page/:page (page : Number) {
    parallel {
      Stores.Application.setPage(Page::Domains)
      Stores.Domains.getDomains(page)
      Stores.Domains.setCurrentPage(page)
      Stores.Domains.getPageCount()
    }
  }

  /domains/show/:name (name : String) {
    parallel {
      Stores.Application.setPage(Page::Domains.Show)
      Stores.Domains.getDomain(name)
    }
  }

  /tokens {
    parallel {
      Stores.Application.setPage(Page::Tokens)
      Stores.Tokens.getTokens(1)
      Stores.Tokens.setCurrentPage(1)
      Stores.Tokens.getPageCount()
    }
  }

  /tokens/page/:page (page : Number) {
    parallel {
      Stores.Application.setPage(Page::Tokens)
      Stores.Tokens.getTokens(page)
      Stores.Tokens.setCurrentPage(page)
      Stores.Tokens.getPageCount()
    }
  }

  /tokens/show/:name (name : String) {
    parallel {
      Stores.Application.setPage(Page::Tokens.Show)
      Stores.Tokens.getToken(name)
    }
  }

  /transactions {
    parallel {
      Stores.Application.setPage(Page::Transactions)
      Stores.Transactions.getTransactions(1)
      Stores.Transactions.setCurrentPage(1)
      Stores.Transactions.getPageCount()
    }
  }

  /transactions/page/:page (page : Number) {
    parallel {
      Stores.Application.setPage(Page::Transactions)
      Stores.Transactions.getTransactions(page)
      Stores.Transactions.setCurrentPage(page)
      Stores.Transactions.getPageCount()
    }
  }

  /transactions/show/:txid (txid : String) {
    parallel {
      Stores.Application.setPage(Page::Transactions.Show)
      Stores.Transactions.getTransaction(txid)
    }
  }

  / {
    parallel {
      Stores.Application.setPage(Page::Home)
      Stores.Blocks.loadTop()
      Stores.Transactions.loadTop()
    }
  }
}
