function reformatDate(date: string): string {
    const months: {[k: string]: string} = {Jan:"01",Feb:"02",Mar:"03",Apr:"04",
        May:"05",Jun:"06",Jul:"07",Aug:"08",Sep:"09",Oct:"10",Nov:"11",Dec:"12"};
    const parts = date.trim().split(/\s+/);
    if (parts.length < 3) return "";
    let day = parts[0].length >= 2 ? parts[0].slice(0, -2) : parts[0];
    if (day.length === 1) day = "0" + day;
    const month = months[parts[1]] || "01";
    return parts[2] + "-" + month + "-" + day;
}
