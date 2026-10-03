class Solution {
    fun maximumBeauty(flowers: IntArray, newFlowers: Long, target: Int, full: Int, partial: Int): Long {
        val n = flowers.size
        if (n == 0) return 0L
        val fl = IntArray(n) { minOf(flowers[it], target) }
        fl.sort()
        val pre = LongArray(n + 1)
        for (i in 0 until n) pre[i + 1] = pre[i] + fl[i]
        if (fl[0] == target) return full.toLong() * n
        var ans = 0L
        for (i in n downTo 0) {
            val costComplete = target.toLong() * (n - i) - (pre[n] - pre[i])
            if (costComplete > newFlowers) continue
            val rem = newFlowers - costComplete
            if (i == 0) {
                ans = maxOf(ans, full.toLong() * (n - i))
                continue
            }
            var lo = 0
            var hi = target - 1
            var bestMin = 0
            while (lo <= hi) {
                val v = lo + (hi - lo) / 2
                val k = lowerBound(fl, i, v)
                val cost = v.toLong() * k - pre[k]
                if (cost <= rem) {
                    bestMin = v
                    lo = v + 1
                } else {
                    hi = v - 1
                }
            }
            ans = maxOf(ans, full.toLong() * (n - i) + bestMin.toLong() * partial)
        }
        return ans
    }

    // first index in fl[0 until end) whose value is >= v
    private fun lowerBound(fl: IntArray, end: Int, v: Int): Int {
        var lo = 0
        var hi = end
        while (lo < hi) {
            val mid = (lo + hi) ushr 1
            if (fl[mid] < v) lo = mid + 1 else hi = mid
        }
        return lo
    }
}
