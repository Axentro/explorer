module Token {
  fun empty : Token {
    {
      name = "",
      timestamp = Time.now()
    }
  }

  fun decode (object : Object) : Result(Object.Error, Token) {
    decode object as Token
  }

  fun decodes (object : Object) : Result(Object.Error, Array(Token)) {
    decode object as Array(Token)
  }

  fun renderHeaderFooterTable : Html {
    <tr>
      <th>
        "Name"
      </th>

      <th>
        "Time"
      </th>
    </tr>
  }

  fun renderLine (token : Token) : Html {
    <tr>
      <td>
        <a href={"/tokens/show/" + token.name}>
          <{ token.name }>
        </a>
      </td>

      <td>
        <{ DDate.formatFromTS(token.timestamp) }>
      </td>
    </tr>
  }
}
