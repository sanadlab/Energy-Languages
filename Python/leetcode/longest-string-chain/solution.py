class Solution:
    def longestStrChain(self, words):
        words.sort(key=len)
        dp = {}
        best = 1
        for w in words:
            cur = 1
            for i in range(len(w)):
                pred = w[:i] + w[i + 1:]
                if pred in dp:
                    cur = max(cur, dp[pred] + 1)
            dp[w] = cur
            best = max(best, cur)
        return best
