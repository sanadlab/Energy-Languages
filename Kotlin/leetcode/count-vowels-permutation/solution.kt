class Solution {
    fun countVowelPermutation(n: Int): Int {
        val MOD = 1_000_000_007L

        val dp = Array(n + 1) { LongArray(5) }

        for (i in 0 until 5) {
            dp[1][i] = 1L
        }

        for (i in 2..n) {
            dp[i][0] = dp[i - 1][1] % MOD
            dp[i][1] = (dp[i - 1][0] + dp[i - 1][2]) % MOD
            dp[i][2] = (dp[i - 1][0] + dp[i - 1][1] + dp[i - 1][3] + dp[i - 1][4]) % MOD
            dp[i][3] = (dp[i - 1][2] + dp[i - 1][4]) % MOD
            dp[i][4] = dp[i - 1][0] % MOD
        }

        var sum = 0L
        for (v in dp[n]) {
            sum += v
        }
        return (sum % MOD).toInt()
    }
}
