component Search {
  connect Stores.Application exposing { errorMsg, successMsg }
  state searchValue : String = ""

  property navigateURL : String = "/"

  fun onSearchValue (event : Html.Event) {
    next { searchValue = Dom.getValue(event.target) }
  }

  fun render : Html {
    <form class="form-inline my-2 my-lg-0">
      <input
        id="searchInput"
        class="form-control mr-sm-2"
        type="search"
        onInput={onSearchValue}
        value={searchValue}
        placeholder="search by address, transaction, block, domain, token"
        aria-label="Search"/>

      <button
        class="btn btn-outline-light my-2 my-sm-0"
        onClick={(e : Html.Event) { searchLookup(searchValue) }}
        type="submit">

        "Search"

      </button>
    </form>
  }

  fun searchLookup (val : String) {
    sequence {
      response =
        "/api/v1/search/" + val
        |> Http.post()
        |> Http.send()

      try {
        object =
          response.body
          |> Json.parse()
          |> Maybe.toResult("[searchLookup] Json error when retrieving search results")

        data =
          decode object as SearchResult

        if (data.results == 0) {
          Stores.Application.setErrorMsg("[SearchResult.results] No result for " + val + "query string")
        } else {
          sequence {
            Stores.Application.setErrorMsg("")
            Stores.Application.setSuccessMsg(Maybe.withDefault("", data.controller) + " found")

            navigateURL =
              "/" + Maybe.withDefault("", data.controller) + "/show/" + val

            /* Window.navigate(navigateURL) */
            `window.location.replace(#{navigateURL})`
          }
        }
      } catch Object.Error => error {
        Stores.Application.setErrorMsg("[Object.Error] Search result error")
      } catch String => error {
        Stores.Application.setErrorMsg("[String] " + error)
      }
    } catch Http.ErrorResponse => error {
      Stores.Application.setErrorMsg("[Http.ErrorResponse] Search result error")
    }
  }
}
