class Solution {
    fun average(salary: IntArray): Double {
        var mn = salary[0]
        var mx = salary[0]
        var total = 0
        for (s in salary) {
            total += s
            mn = minOf(mn, s)
            mx = maxOf(mx, s)
        }
        return (total - mn - mx).toDouble() / (salary.size - 2)
    }
}
