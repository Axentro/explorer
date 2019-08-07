store Stores.Blocks {
  state blocks : Array(Block) = []
  state block : Block = Block.empty()

  fun loadTop (top : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/blocks/top/" + Number.toString(top)
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

  fun getBlock (index : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/block/" + Number.toString(index)
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving blocks")

        data =
          Block.decode(object)

        next { block = data }
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

  fun getBlocks (page : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/blocks/page/" + Number.toString(page) + "/length/-1"
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
