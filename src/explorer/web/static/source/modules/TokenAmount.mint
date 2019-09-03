module TokenAmount {
  fun empty : TokenAmount {
    {
      token = "",
      amount = 0
    }
  }

  /*
  fun decode (object : Object) : Result(Object.Error, Token) {
    decode object as Token
  }

  fun decodes (object : Object) : Result(Object.Error, Array(Token)) {
    decode object as Array(Token)
  }
  */
  fun renderHeaderFooterTable : Html {
    <tr>
      <th>
        "Token"
      </th>

      <th>
        "Amount"
      </th>
    </tr>
  }

  fun renderLine (tm : TokenAmount) : Html {
    <tr>
      <td>
        <a href={"/tokens/show/" + tm.token}>
          <{ tm.token }>
        </a>
      </td>

      <td>
        <{ NNumber.toScale8(Number.toString(tm.amount)) }>
      </td>
    </tr>
  }
}
