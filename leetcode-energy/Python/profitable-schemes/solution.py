from typing import List

class Solution:
    def profitableSchemes(self, n: int, minProfit: int, group: List[int], profit: List[int]) -> int:
        MOD = 10**9 + 7
        
        dp = [[0] * (minProfit + 1) for _ in range(n + 1)]
        dp[0][0] = 1
        
        for members, gain in zip(group, profit):
            for used in range(n - members, -1, -1):
                for curr_profit in range(minProfit + 1):
                    new_profit = min(minProfit, curr_profit + gain)
                    dp[used + members][new_profit] = (
                        dp[used + members][new_profit] + dp[used][curr_profit]
                    ) % MOD
        
        return sum(dp[used][minProfit] for used in range(n + 1)) % MOD
