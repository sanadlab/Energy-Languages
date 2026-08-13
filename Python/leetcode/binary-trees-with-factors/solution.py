class Solution:
    def numFactoredBinaryTrees(self, arr):
        arr.sort()
        MOD = 10**9 + 7
        dp = {}
        for i, v in enumerate(arr):
            cnt = 1
            for j in range(i):
                a = arr[j]
                if v % a == 0:
                    b = v // a
                    if b in dp:
                        cnt += dp[a] * dp[b]
            dp[v] = cnt % MOD
        return sum(dp.values()) % MOD
