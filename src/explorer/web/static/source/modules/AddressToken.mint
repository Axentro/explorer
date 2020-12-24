module AddressToken {
  fun renderHeaderFooterTable : Html {
    <tr>
      <th>"Token"</th>

      <th>"Amount"</th>
    </tr>
  }

  fun renderLine (token : String, amount : Number) : Html {
    <tr>
      <td>
        <a href={"/tokens/show/" + token}>
          <{ token }>
        </a>
      </td>

      <td>
        <{ Number.toString(amount) }>
      </td>
    </tr>
  }
}
