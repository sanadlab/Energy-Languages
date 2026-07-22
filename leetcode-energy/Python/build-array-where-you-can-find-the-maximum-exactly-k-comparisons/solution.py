class Solution:
    def numOfArrays(self, n: int, m: int, k: int) -> int:
        MOD = 10**9 + 7
        
        if k == 0 or k > n or k > m:
            return 0
        
        dp = [[0] * (m + 1) for _ in range(k + 1)]
        for max_val in range(1, m + 1):
            dp[1][max_val] = 1
        
        for _ in range(2, n + 1):
            new_dp = [[0] * (m + 1) for _ in range(k + 1)]
            
            for cost in range(1, k + 1):
                prefix = 0
                for max_val in range(1, m + 1):
                    new_dp[cost][max_val] = (dp[cost][max_val] * max_val + prefix) % MOD
                    if cost > 1:
                        prefix = (prefix + dp[cost - 1][max_val]) % MOD
            
            dp = new_dp
        
        return sum(dp[k]) % MOD
