class Solution {
    fun maxSizeSlices(slices: IntArray): Int {
        fun best(nums: IntArray, k: Int): Int {
            val n = nums.size
            val NEG = Int.MIN_VALUE / 2
            val dp = Array(n + 1) { IntArray(k + 1) { NEG } }
            for (i in 0..n) dp[i][0] = 0
            for (i in 1..n) {
                for (j in 1..k) {
                    val skip = dp[i - 1][j]
                    val prev = if (i >= 2) dp[i - 2][j - 1] else (if (j == 1) 0 else NEG)
                    val take = prev + nums[i - 1]
                    dp[i][j] = maxOf(skip, take)
                }
            }
            return dp[n][k]
        }

        val total = slices.size
        val k = total / 3
        if (k == 0) return 0
        return maxOf(
            best(slices.copyOfRange(0, total - 1), k),
            best(slices.copyOfRange(1, total), k)
        )
    }
}
