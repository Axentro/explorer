module Domain {
  fun empty : Domain {
    {
      name = "",
      address = "",
      timestamp = 0
    }
  }

  fun decode (object : Object) : Result(Object.Error, Domain) {
    decode object as Domain
  }

  fun decodes (object : Object) : Result(Object.Error, Array(Domain)) {
    decode object as Array(Domain)
  }

  fun renderHeaderFooterTable : Html {
    <tr>
      <th>"Name"</th>

      <th>"Address"</th>

      <th>"Time"</th>
    </tr>
  }

  fun renderLine (domain : Domain) : Html {
    <tr>
      <td>
        <a href={"/domains/show/" + domain.name}>
          <{ domain.name }>
        </a>
      </td>

      <td>
        <a href={"/addresses/show/" + domain.address}>
          <{ domain.address }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(domain.timestamp) }>
      </td>
    </tr>
  }

  fun renderInAddressHeaderFooterTable : Html {
    <tr>
      <th>"Name"</th>

      <th>"Time"</th>
    </tr>
  }

  fun renderInAddressLine (domain : Domain) : Html {
    <tr>
      <td>
        <a href={"/domains/show/" + domain.name}>
          <{ domain.name }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(domain.timestamp) }>
      </td>
    </tr>
  }
}
