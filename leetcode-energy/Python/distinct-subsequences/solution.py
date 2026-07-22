class Solution:
    def numDistinct(self, s: str, t: str) -> int:
        n, m = len(s), len(t)
        if m > n:
            return 0

        dp = [0] * (m + 1)
        dp[0] = 1

        for char in s:
            for j in range(m - 1, -1, -1):
                if t[j] == char:
                    dp[j + 1] += dp[j]

        return dp[m]
