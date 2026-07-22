class Solution:
    def longestPalindrome(self, word1: str, word2: str) -> int:
        s = word1 + word2
        m, n = len(word1), len(word1) + len(word2)
        dp = [0] * n
        ans = 0

        for i in range(n - 1, -1, -1):
            prev = 0
            dp[i] = 1
            for j in range(i + 1, n):
                temp = dp[j]

                if s[i] == s[j]:
                    take = prev + 2

                    if i < m <= j:
                        ans = max(ans, take)

                    dp[j] = max(dp[j], dp[j - 1], take)
                else:
                    dp[j] = max(dp[j], dp[j - 1])

                prev = temp

        return ans
