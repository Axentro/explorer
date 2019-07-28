store Stores.Transactions {
  state transactions : Array(Transaction) = []

  fun load : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/transactions/limit/10"
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
}
