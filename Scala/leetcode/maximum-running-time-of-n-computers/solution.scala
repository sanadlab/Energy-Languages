object Solution {
    def maxRunTime(n: Int, batteries: Array[Int]): Long = {
        val total = batteries.map(_.toLong).sum
        var lo = 0L
        var hi = total / n
        while (lo < hi) {
            val mid = (lo + hi + 1) / 2
            var avail = 0L
            for (b <- batteries) avail += math.min(b.toLong, mid)
            if (avail >= n.toLong * mid) lo = mid
            else hi = mid - 1
        }
        lo
    }
}
