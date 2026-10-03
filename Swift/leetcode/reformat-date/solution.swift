class Solution {
    func reformatDate(_ date: String) -> String {
        let months = ["Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04",
                      "May": "05", "Jun": "06", "Jul": "07", "Aug": "08",
                      "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"]
        let parts = date.split(separator: " ").map { String($0) }
        if parts.count < 3 {
            return ""
        }
        var day: String
        let p0 = Array(parts[0])
        if p0.count >= 2 {
            day = String(p0[0..<(p0.count - 2)])
        } else {
            day = parts[0]
        }
        if day.count == 1 {
            day = "0" + day
        }
        let month = months[parts[1]] ?? "01"
        return parts[2] + "-" + month + "-" + day
    }
}
