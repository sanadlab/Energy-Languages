object Solution {
    def isMatch(s: String, p: String): Boolean = {
        val m = s.length
        val n = p.length
        val dp = Array.fill(m + 1, n + 1)(false)
        dp(m)(n) = true
        for (i <- m to 0 by -1) {
            for (j <- n - 1 to 0 by -1) {
                val first = i < m && (p(j) == s(i) || p(j) == '.')
                if (j + 1 < n && p(j + 1) == '*') {
                    dp(i)(j) = dp(i)(j + 2) || (first && dp(i + 1)(j))
                } else {
                    dp(i)(j) = first && dp(i + 1)(j + 1)
                }
            }
        }
        dp(0)(0)
    }
}
