object Solution {
    def minDays(bloomDay: Array[Int], m: Int, k: Int): Int = {
        if (m.toLong * k > bloomDay.length) return -1
        def canMake(day: Int): Boolean = {
            var bouquets = 0
            var flowers = 0
            for (b <- bloomDay) {
                if (b <= day) {
                    flowers += 1
                    if (flowers == k) {
                        bouquets += 1
                        flowers = 0
                    }
                } else {
                    flowers = 0
                }
            }
            bouquets >= m
        }
        var lo = bloomDay.min
        var hi = bloomDay.max
        while (lo < hi) {
            val mid = (lo + hi) / 2
            if (canMake(mid)) hi = mid
            else lo = mid + 1
        }
        lo
    }
}
