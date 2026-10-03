object Solution {
    def daysBetweenDates(date1: String, date2: String): Int = {
        def daysFromCivil(y0: Int, mo: Int, d: Int): Int = {
            val y = y0 - (if (mo <= 2) 1 else 0)
            val era = (if (y >= 0) y else y - 399) / 400
            val yoe = y - era * 400
            val doy = (153 * (mo + (if (mo > 2) -3 else 9)) + 2) / 5 + d - 1
            val doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
            era * 146097 + doe - 719468
        }
        def days(s: String): Int = {
            val parts = s.split("-")
            val vals = Array(0, 0, 0)
            for (i <- 0 until math.min(3, parts.length)) {
                vals(i) = try { parts(i).toInt } catch { case _: NumberFormatException => 0 }
            }
            daysFromCivil(vals(0), vals(1), vals(2))
        }
        math.abs(days(date1) - days(date2))
    }
}
