class Solution:
    def numFactoredBinaryTrees(self, arr: list[int]) -> int:
        MOD = 10**9 + 7
        arr.sort()
        dp = {}
        arr_set = set(arr)
        
        for x in arr:
            dp[x] = 1  # single node tree
        
        for i, x in enumerate(arr):
            for j in range(i):
                y = arr[j]
                if x % y == 0:
                    z = x // y
                    if z in dp:
                        dp[x] = (dp[x] + dp[y] * dp[z]) % MOD
        
        return sum(dp.values()) % MOD
