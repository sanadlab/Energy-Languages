object Solution {
    def countVowelPermutation(n: Int): Int = {
        val MOD = 1000000007L
        val dp = Array.ofDim[Long](n + 1, 5)
        for (i <- 0 until 5) dp(1)(i) = 1L
        for (i <- 2 to n) {
            dp(i)(0) = dp(i - 1)(1) % MOD
            dp(i)(1) = (dp(i - 1)(0) + dp(i - 1)(2)) % MOD
            dp(i)(2) = (dp(i - 1)(0) + dp(i - 1)(1) + dp(i - 1)(3) + dp(i - 1)(4)) % MOD
            dp(i)(3) = (dp(i - 1)(2) + dp(i - 1)(4)) % MOD
            dp(i)(4) = dp(i - 1)(0) % MOD
        }
        (dp(n).sum % MOD).toInt
    }
}
