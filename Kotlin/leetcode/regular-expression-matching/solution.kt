class Solution {
    fun isMatch(s: String, p: String): Boolean {
        val m = s.length
        val n = p.length
        val dp = Array(m + 1) { BooleanArray(n + 1) }
        dp[m][n] = true
        for (i in m downTo 0) {
            for (j in n - 1 downTo 0) {
                val first = i < m && (p[j] == s[i] || p[j] == '.')
                if (j + 1 < n && p[j + 1] == '*') {
                    dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j])
                } else {
                    dp[i][j] = first && dp[i + 1][j + 1]
                }
            }
        }
        return dp[0][0]
    }
}
