from typing import List

class Solution:
    def numWays(self, words: List[str], target: str) -> int:
        MOD = 10**9 + 7
        cols = len(words[0])
        m = len(target)

        if m > cols:
            return 0

        counts = [[0] * 26 for _ in range(cols)]
        for word in words:
            for i, ch in enumerate(word):
                counts[i][ord(ch) - ord('a')] += 1

        target_idx = [ord(ch) - ord('a') for ch in target]
        dp = [0] * (m + 1)
        dp[0] = 1

        for col in range(cols):
            cnt = counts[col]
            for i in range(min(m - 1, col), -1, -1):
                ways = cnt[target_idx[i]]
                if ways:
                    dp[i + 1] = (dp[i + 1] + dp[i] * ways) % MOD

        return dp[m]
