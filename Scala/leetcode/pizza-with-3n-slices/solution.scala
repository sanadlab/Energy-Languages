object Solution {
    def maxSizeSlices(slices: Array[Int]): Int = {
        val NEG = Long.MinValue / 4
        def best(nums: Array[Int], k: Int): Long = {
            val n = nums.length
            val dp = Array.fill(n + 1, k + 1)(NEG)
            for (i <- 0 to n) dp(i)(0) = 0L
            for (i <- 1 to n) {
                for (j <- 1 to k) {
                    val skip = dp(i - 1)(j)
                    val prev = if (i >= 2) dp(i - 2)(j - 1) else (if (j == 1) 0L else NEG)
                    val take = prev + nums(i - 1)
                    dp(i)(j) = math.max(skip, take)
                }
            }
            dp(n)(k)
        }
        val total = slices.length
        val k = total / 3
        if (k == 0) return 0
        math.max(best(slices.dropRight(1), k), best(slices.drop(1), k)).toInt
    }
}
