class Solution {
    fun minDays(bloomDay: IntArray, m: Int, k: Int): Int {
        if (m.toLong() * k > bloomDay.size) return -1
        fun canMake(day: Int): Boolean {
            var bouquets = 0
            var flowers = 0
            for (b in bloomDay) {
                if (b <= day) {
                    flowers++
                    if (flowers == k) {
                        bouquets++
                        flowers = 0
                    }
                } else {
                    flowers = 0
                }
            }
            return bouquets >= m
        }
        var lo = bloomDay[0]
        var hi = bloomDay[0]
        for (b in bloomDay) {
            if (b < lo) lo = b
            if (b > hi) hi = b
        }
        while (lo < hi) {
            val mid = (lo + hi) / 2
            if (canMake(mid)) hi = mid else lo = mid + 1
        }
        return lo
    }
}
