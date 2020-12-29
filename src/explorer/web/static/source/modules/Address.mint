module Address {
  fun empty : Address {
    {
      address = "",
      tokenAmounts = Map.empty(),
      domains = [],
      timestamp = 0
    }
  }

  fun decode (object : Object) : Result(Object.Error, Address) {
    decode object as Address
  }

  fun decodes (object : Object) : Result(Object.Error, Array(Address)) {
    decode object as Array(Address)
  }

  fun renderHeaderFooterTable : Html {
    <tr>
      <th>
        "Address"
      </th>

      <th>
        "AXNT amount"
      </th>

      <th>
        "Number of tokens"
      </th>

      <th>
        "Number of domains"
      </th>

      <th>
        "Time"
      </th>
    </tr>
  }

  fun renderLine (address : Address) : Html {
    <tr>
      <td>
        <a href={"/addresses/show/" + address.address}>
          <{ address.address }>
        </a>
      </td>

      <td>
        <{
          Number.toString(
            (address.tokenAmounts
            |> Map.getWithDefault("AXNT", 0.0)))
        }>
      </td>

      <td>
        <{
          Number.toString(
            (address.tokenAmounts
            |> Map.size()))
        }>
      </td>

      <td>
        <{ Number.toString(Array.size(address.domains)) }>
      </td>

      <td>
        <{ DDate.formatFromTSM(address.timestamp) }>
      </td>
    </tr>
  }
}
