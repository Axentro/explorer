module DDate {
  fun formatFromTS (timestamp : Number) : String {
    `
    (() => {
        let locale = navigator.language || navigator.userLanguage || "en-US";
        let millisecond = #{timestamp} * 1000;
        let d = new Date(millisecond);
        //return d.toLocaleString(locale, { timeZone: 'UTC' });
        return d.toLocaleString(locale);
    })()
    `
  }

  fun tsModulo (seconds : Number) : Bool {
    `
    (() => {
      let s = Date.now() / 1000 | 0;
      return (s % #{seconds}) == 0;
    })()
    `
  }
}
