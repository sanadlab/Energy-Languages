object Solution {
    def numOfWays(nums: Array[Int]): Int = {
        val MOD = 1000000007L
        val n = nums.length
        val C = Array.ofDim[Long](n + 1, n + 1)
        for (i <- 0 to n) {
            C(i)(0) = 1L
            for (j <- 1 to i) {
                C(i)(j) = (C(i - 1)(j - 1) + C(i - 1)(j)) % MOD
            }
        }
        def ways(arr: Array[Int]): Long = {
            val m = arr.length
            if (m <= 2) return 1L
            val root = arr(0)
            val rest = arr.drop(1)
            val left = rest.filter(_ < root)
            val right = rest.filter(_ > root)
            C(m - 1)(left.length) * ways(left) % MOD * ways(right) % MOD
        }
        (((ways(nums) - 1) % MOD + MOD) % MOD).toInt
    }
}
