class Solution {
    fun maxRunTime(n: Int, batteries: IntArray): Long {
        var total = 0L
        for (b in batteries) total += b
        var lo = 0L
        var hi = total / n
        while (lo < hi) {
            val mid = (lo + hi + 1) / 2
            var avail = 0L
            for (b in batteries) avail += minOf(b.toLong(), mid)
            if (avail >= n * mid) {
                lo = mid
            } else {
                hi = mid - 1
            }
        }
        return lo
    }
}
