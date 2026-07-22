from typing import List
from collections import Counter

class Solution:
    def canDistribute(self, nums: List[int], quantity: List[int]) -> bool:
        counts = list(Counter(nums).values())
        
        if sum(quantity) > len(nums):
            return False
        if max(quantity) > max(counts):
            return False
        
        m = len(quantity)
        full = (1 << m) - 1
        
        subset_sum = [0] * (1 << m)
        for mask in range(1, 1 << m):
            lsb = mask & -mask
            idx = lsb.bit_length() - 1
            subset_sum[mask] = subset_sum[mask ^ lsb] + quantity[idx]
        
        dp = [False] * (1 << m)
        dp[0] = True
        
        for count in counts:
            ndp = dp[:]
            for mask in range(1 << m):
                if not dp[mask]:
                    continue
                
                remaining = full ^ mask
                sub = remaining
                
                while sub:
                    if subset_sum[sub] <= count:
                        ndp[mask | sub] = True
                    sub = (sub - 1) & remaining
            
            dp = ndp
            
            if dp[full]:
                return True
        
        return dp[full]
