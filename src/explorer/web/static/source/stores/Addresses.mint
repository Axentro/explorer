store Stores.Addresses {
  state addresses : Array(Address) = []
  state address : Address = Address.empty()
  state currentPage : Number = 1
  state pageCount : Number = 1

  fun setCurrentPage (cp : Number) : Promise(Never, Void) {
    next { currentPage = cp }
  }

  fun getAddress (address : String) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/address/" + address
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving address")

        data =
          Address.decode(object)

        next { address = data }
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

  fun getAddresses (page : Number) : Promise(Never, Void) {
    sequence {
      response =
        "/api/v1/addresses/page/" + Number.toString(page) + "/length/-1"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving addresses")

        data =
          Address.decodes(object)

        next { addresses = data }
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
        "/api/v1/addresses/pageCount"
        |> Http.get()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("Json error when retrieving addresses")

        data =
          decode object as AddressesPageCount

        next { pageCount = data.addressesPageCount }
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
