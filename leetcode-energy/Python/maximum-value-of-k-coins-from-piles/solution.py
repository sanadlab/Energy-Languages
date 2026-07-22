from typing import List

class Solution:
    def maxValueOfCoins(self, piles: List[List[int]], k: int) -> int:
        neg = -10**18
        dp = [neg] * (k + 1)
        dp[0] = 0
        
        available = 0
        
        for pile in piles:
            prefix = [0]
            total = 0
            
            for coin in pile[:k]:
                total += coin
                prefix.append(total)
            
            m = len(prefix) - 1
            old_available = available
            available = min(k, available + m)
            
            for j in range(available, 0, -1):
                best = dp[j] if j <= old_available else neg
                
                lo = max(1, j - old_available)
                hi = min(m, j)
                
                for x in range(lo, hi + 1):
                    best = max(best, dp[j - x] + prefix[x])
                
                dp[j] = best
        
        return dp[k]
