store Stores.Tokens {
  state tokens : Array(Token) = []
  state token : Token = Token.empty()
  state currentPage : Number = 1
  state pageCount : Number = 1

  fun setCurrentPage (cp : Number) : Promise(Never, Void) {
    next { currentPage = cp }
  }

  fun getToken (name : String) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/token/" + name
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving token")

        data =
          Token.decode(object)

        next { token = data }
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

  fun getTokens (page : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/tokens/page/" + Number.toString(page) + "/length/-1"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving tokens")

        data =
          Token.decodes(object)

        next { tokens = data }
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
        "/api/v1/tokens/pageCount"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving tokens")

        data =
          decode object as TokensPageCount

        next { pageCount = data.tokensPageCount }
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
