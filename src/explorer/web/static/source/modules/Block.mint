module Block {
  fun empty : Block {
    {
      index = -1,
      transactions = [],
      nonce = Maybe.just("0"),
      prevHash = "",
      merkleTreeRoot = "",
      timestamp = 0,
      difficulty = Maybe.just(0),
      kind = "",
      address = "",
      publicKey = Maybe.just(""),
      signature = Maybe.just(""),
      hash = Maybe.just("")
    }
  }

  fun decode (object : Object) : Result(Object.Error, Block) {
    decode object as Block
  }

  fun renderHeaderFooterTable : Html {
    <tr>
      <th>
        "Index"
      </th>

      <th>
        "Address"
      </th>

      <th>
        "Time"
      </th>

      <th>
        "Number of tx"
      </th>
    </tr>
  }

  fun renderLine (block : Block) : Html {
    <tr>
      <td>
        if (block.index % 2 == 0) {
          <i
            class="fas fa-hourglass"
            title="slow"/>
        } else {
          <i
            class="fas fa-bolt"
            title="fast"/>
        }

        " - "

        <a href={"/blocks/show/" + Number.toString(block.index)}>
          <{ Number.toString(block.index) }>
        </a>
      </td>

      <td>
        <a
          href={"/addresses/show/" + block.address}
          title={block.address}>

          <{ block.address }>

        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(block.timestamp) }>
      </td>

      <td>
        <{ Number.toString(Array.size(block.transactions)) }>
      </td>
    </tr>
  }

  fun renderLineShrink (block : Block) : Html {
    <tr>
      <td>
        if (block.index % 2 == 0) {
          <i
            class="fas fa-hourglass"
            title="slow"/>
        } else {
          <i
            class="fas fa-bolt"
            title="fast"/>
        }

        " - "

        <a href={"/blocks/show/" + Number.toString(block.index)}>
          <{ Number.toString(block.index) }>
        </a>
      </td>

      <td>
        <a
          href={"/addresses/show/" + block.address}
          title={block.address}>

          <{ SString.substring(block.address, 0, 16) + "..." }>

        </a>
      </td>

      <td>
        <{ DDate.formatFromTSM(block.timestamp) }>
      </td>

      <td>
        <{ Number.toString(Array.size(block.transactions)) }>
      </td>
    </tr>
  }
}
