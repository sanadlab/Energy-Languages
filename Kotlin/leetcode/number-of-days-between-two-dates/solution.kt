class Solution {
    fun daysBetweenDates(date1: String, date2: String): Int {
        val a = days(date1)
        val b = days(date2)
        return Math.abs(a - b)
    }

    private fun days(s: String): Int {
        val parts = s.split("-")
        val vals = intArrayOf(0, 0, 0)
        for (i in 0 until minOf(3, parts.size)) {
            vals[i] = parts[i].toIntOrNull() ?: 0
        }
        return daysFromCivil(vals[0], vals[1], vals[2])
    }

    private fun daysFromCivil(yIn: Int, m: Int, d: Int): Int {
        val y = yIn - (if (m <= 2) 1 else 0)
        val era = Math.floorDiv(y, 400)
        val yoe = y - era * 400
        val doy = (153 * (m + (if (m > 2) -3 else 9)) + 2) / 5 + d - 1
        val doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
        return era * 146097 + doe - 719468
    }
}
