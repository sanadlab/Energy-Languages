object Solution {
    def splitArray(nums: Array[Int], k: Int): Int = {
        var lo = nums.map(_.toLong).max
        var hi = nums.map(_.toLong).sum
        while (lo < hi) {
            val mid = (lo + hi) / 2
            var cnt = 1
            var cur = 0L
            for (x <- nums) {
                if (cur + x > mid) { cnt += 1; cur = x }
                else cur += x
            }
            if (cnt <= k) hi = mid
            else lo = mid + 1
        }
        lo.toInt
    }
}
