module DDate {
  fun formatFromTS (timestamp : Time) : String {
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
}
