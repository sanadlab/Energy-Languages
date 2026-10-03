class Solution {
    fun reformatDate(date: String): String {
        val months = mapOf(
            "Jan" to "01", "Feb" to "02", "Mar" to "03", "Apr" to "04",
            "May" to "05", "Jun" to "06", "Jul" to "07", "Aug" to "08",
            "Sep" to "09", "Oct" to "10", "Nov" to "11", "Dec" to "12"
        )
        val parts = date.trim().split(Regex("\\s+"))
        if (parts.size < 3) return ""
        var day = if (parts[0].length >= 2) parts[0].substring(0, parts[0].length - 2) else parts[0]
        if (day.length == 1) day = "0" + day
        val month = months.getOrDefault(parts[1], "01")
        return parts[2] + "-" + month + "-" + day
    }
}
