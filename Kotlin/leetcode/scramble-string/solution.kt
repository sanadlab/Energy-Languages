class Solution {
    fun isScramble(s1: String, s2: String): Boolean {
        if (s1.length != s2.length) return false
        val n = s1.length
        val dp = Array(n + 1) { Array(n) { BooleanArray(n) } }

        fun checkEqual(i1: Int, i2: Int, length: Int): Boolean {
            val a = s1.substring(i1, i1 + length).toCharArray()
            val b = s2.substring(i2, i2 + length).toCharArray()
            a.sort()
            b.sort()
            return a.contentEquals(b)
        }

        for (length in 1..n) {
            for (i in 0..n - length) {
                for (j in 0..n - length) {
                    if (checkEqual(i, j, length) && length == 1) {
                        dp[length][i][j] = true
                    } else if (checkEqual(i, j, length)) {
                        for (k in 1 until length) {
                            if ((dp[k][i][j] && dp[length - k][i + k][j + k]) ||
                                (dp[k][i][j + length - k] && dp[length - k][i + k][j])
                            ) {
                                dp[length][i][j] = true
                                break
                            }
                        }
                    }
                }
            }
        }

        return dp[n][0][0]
    }
}
