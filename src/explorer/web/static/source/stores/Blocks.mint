store Stores.Blocks {
  state blocks : Array(Block) = []

  fun load : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/blocks/limit/10"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving blocks")

        data =
          decode object as Array(Block)

        next { blocks = data }
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
