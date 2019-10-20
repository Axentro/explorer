module DDate {
  fun formatFromTS (timestamp : Number) : String {
    `
    (() => {
        let locale = navigator.language || navigator.userLanguage || "en-US";
        let second = #{timestamp};
        let d = new Date(second * 1000);
        //return d.toLocaleString(locale, { timeZone: 'UTC' });
        return d.toLocaleString(locale);
    })()
    `
  }

  fun formatFromTSM (timestamp : Number) : String {
    `
    (() => {
        let locale = navigator.language || navigator.userLanguage || "en-US";
        let millisecond = #{timestamp};
        let d = new Date(millisecond);
        //return d.toLocaleString(locale, { timeZone: 'UTC' });
        return d.toLocaleString(locale);
    })()
    `
  }
}
