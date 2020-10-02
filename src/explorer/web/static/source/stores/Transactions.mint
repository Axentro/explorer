store Stores.Transactions {
  state transactions : Array(Transaction) = []
  state transaction : Transaction = Transaction.empty()
  state currentPage : Number = 1
  state pageCount : Number = 1

  fun setCurrentPage (cp : Number) : Promise(Never, Void) {
    next { currentPage = cp }
  }

  fun loadTop (top : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/transactions/top/" + Number.toString(top)
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving transactions")

        data =
          decode object as Array(Transaction)

        next { transactions = data }
      } catch Object.Error => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      } catch String => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      }
    } catch Http.ErrorResponse => error {
      sequence {
        Debug.log(error)
        Promise.never()
      }
    }
  }

  fun getTransaction (txid : String) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/transaction/" + txid
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving transactions")

        data =
          Transaction.decode(object)

        next { transaction = data }
      } catch Object.Error => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      } catch String => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      }
    } catch Http.ErrorResponse => error {
      sequence {
        Debug.log(error)
        Promise.never()
      }
    }
  }

  fun getTransactions (page : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/transactions/page/" + Number.toString(page) + "/length/-1"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving transactions")

        data =
          decode object as Array(Transaction)

        next { transactions = data }
      } catch Object.Error => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      } catch String => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      }
    } catch Http.ErrorResponse => error {
      sequence {
        Debug.log(error)
        Promise.never()
      }
    }
  }

  fun getPageCount : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/transactions/pageCount"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving transactions")

        data =
          decode object as TransactionsPageCount

        next { pageCount = data.transactionsPageCount }
      } catch Object.Error => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      } catch String => error {
        sequence {
          Debug.log(error)
          Promise.never()
        }
      }
    } catch Http.ErrorResponse => error {
      sequence {
        Debug.log(error)
        Promise.never()
      }
    }
  }
}
