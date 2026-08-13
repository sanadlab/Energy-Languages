public class Solution {
    public string ReformatDate(string date) {
        var months = new Dictionary<string,string>{
            {"Jan","01"},{"Feb","02"},{"Mar","03"},{"Apr","04"},
            {"May","05"},{"Jun","06"},{"Jul","07"},{"Aug","08"},
            {"Sep","09"},{"Oct","10"},{"Nov","11"},{"Dec","12"}};
        var parts = date.Split(new[]{' '}, StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length < 3) return "";
        string day = parts[0].Length >= 2 ? parts[0].Substring(0, parts[0].Length - 2) : parts[0];
        if (day.Length == 1) day = "0" + day;
        string month = months.ContainsKey(parts[1]) ? months[parts[1]] : "01";
        return parts[2] + "-" + month + "-" + day;
    }
}
