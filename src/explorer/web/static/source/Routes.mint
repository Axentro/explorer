routes {
  /blocks {
    Application.setPage("blocks")
  }

  /transactions {
    Application.setPage("transactions")
  }

  /addresses {
    Application.setPage("addresses")
  }

  / {
    sequence {
      Application.setPage("home")
      Stores.Blocks.load()
      Stores.Transactions.load()
    }
  }
}
