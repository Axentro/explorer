module NNumber {
  fun toScale8 (strNum : String) : String {
    `
    (() => {
        const numberWithDecimalSeparator = 1.1;
        let separator =  numberWithDecimalSeparator
            .toLocaleString(undefined)
            .substring(1, 2);
        if (#{strNum}.length <= 8) {
            return "0" + separator + #{strNum}
        } else {
            return #{strNum}.slice(0, -8) + separator + #{strNum}.slice(-8)
        }
    })()
    `
  }
}
