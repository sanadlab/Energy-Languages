class Solution {
    fun lengthOfLIS(nums: IntArray): Int {
        val tails = ArrayList<Int>()
        for (x in nums) {
            var lo = 0
            var hi = tails.size
            while (lo < hi) {
                val mid = (lo + hi) / 2
                if (tails[mid] < x) lo = mid + 1 else hi = mid
            }
            if (lo == tails.size) tails.add(x) else tails[lo] = x
        }
        return tails.size
    }
}
