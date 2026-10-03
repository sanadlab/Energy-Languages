class Solution {
    private fun helper(a: IntArray, b: IntArray): Int {
        var cnt = 0
        for (x in a) {
            val t = x.toLong() * x
            val seen = HashMap<Long, Int>()
            for (y in b) {
                val yl = y.toLong()
                if (t % yl == 0L) {
                    val need = t / yl
                    cnt += seen.getOrDefault(need, 0)
                }
                seen[yl] = seen.getOrDefault(yl, 0) + 1
            }
        }
        return cnt
    }

    fun numTriplets(nums1: IntArray, nums2: IntArray): Int {
        return helper(nums1, nums2) + helper(nums2, nums1)
    }
}
