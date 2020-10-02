store Stores.Domains {
  state domains : Array(Domain) = []
  state domain : Domain = Domain.empty()
  state currentPage : Number = 1
  state pageCount : Number = 1

  fun setCurrentPage (cp : Number) : Promise(Never, Void) {
    next { currentPage = cp }
  }

  fun getDomain (name : String) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/domain/" + name
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving domain")

        data =
          Domain.decode(object)

        next { domain = data }
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

  fun getDomains (page : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/domains/page/" + Number.toString(page) + "/length/-1"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving domains")

        data =
          Domain.decodes(object)

        next { domains = data }
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
        "/api/v1/domains/pageCount"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving domains")

        data =
          decode object as DomainsPageCount

        next { pageCount = data.domainsPageCount }
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
