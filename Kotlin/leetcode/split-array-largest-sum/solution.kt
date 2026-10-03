class Solution {
    fun splitArray(nums: IntArray, k: Int): Int {
        var lo = 0
        var hi = 0
        for (x in nums) {
            if (x > lo) lo = x
            hi += x
        }
        while (lo < hi) {
            val mid = (lo + hi) / 2
            var cnt = 1
            var cur = 0
            for (x in nums) {
                if (cur + x > mid) {
                    cnt++
                    cur = x
                } else {
                    cur += x
                }
            }
            if (cnt <= k) {
                hi = mid
            } else {
                lo = mid + 1
            }
        }
        return lo
    }
}
