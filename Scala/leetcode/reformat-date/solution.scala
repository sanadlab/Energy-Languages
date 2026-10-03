object Solution {
    def reformatDate(date: String): String = {
        val months = Map("Jan" -> "01", "Feb" -> "02", "Mar" -> "03", "Apr" -> "04",
            "May" -> "05", "Jun" -> "06", "Jul" -> "07", "Aug" -> "08",
            "Sep" -> "09", "Oct" -> "10", "Nov" -> "11", "Dec" -> "12")
        val parts = date.split("\\s+")
        if (parts.length < 3) ""
        else {
            var day = if (parts(0).length >= 2) parts(0).substring(0, parts(0).length - 2) else parts(0)
            if (day.length == 1) day = "0" + day
            val month = months.getOrElse(parts(1), "01")
            parts(2) + "-" + month + "-" + day
        }
    }
}
