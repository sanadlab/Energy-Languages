object Solution {
    def maximumBeauty(flowers: Array[Int], newFlowers: Long, target: Int, full: Int, partial: Int): Long = {
        val n = flowers.length
        if (n == 0) return 0L
        val fl = flowers.map(f => math.min(f, target)).sorted
        val pre = new Array[Long](n + 1)
        for (i <- 0 until n) pre(i + 1) = pre(i) + fl(i)
        if (fl(0) == target) return full.toLong * n
        def bisectLeft(x: Int, hiBound: Int): Int = {
            var lo = 0
            var hi = hiBound
            while (lo < hi) {
                val mid = (lo + hi) / 2
                if (fl(mid) < x) lo = mid + 1
                else hi = mid
            }
            lo
        }
        var ans = 0L
        var i = n
        while (i >= 0) {
            val costComplete = target.toLong * (n - i) - (pre(n) - pre(i))
            if (costComplete <= newFlowers) {
                val rem = newFlowers - costComplete
                if (i == 0) {
                    ans = math.max(ans, full.toLong * (n - i))
                } else {
                    var lo = 0
                    var hi = target - 1
                    var bestMin = 0L
                    while (lo <= hi) {
                        val v = (lo + hi) / 2
                        val k = bisectLeft(v, i)
                        val cost = v.toLong * k - pre(k)
                        if (cost <= rem) {
                            bestMin = v
                            lo = v + 1
                        } else {
                            hi = v - 1
                        }
                    }
                    ans = math.max(ans, full.toLong * (n - i) + bestMin * partial)
                }
            }
            i -= 1
        }
        ans
    }
}
