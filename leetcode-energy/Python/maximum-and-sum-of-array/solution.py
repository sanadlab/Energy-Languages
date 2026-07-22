from typing import List

class Solution:
    def maximumANDSum(self, nums: List[int], numSlots: int) -> int:
        m = 2 * numSlots
        slot = [i // 2 + 1 for i in range(m)]
        total_masks = 1 << m
        
        dp = [-1] * total_masks
        dp[0] = 0
        ans = 0
        
        for mask in range(total_masks):
            if dp[mask] == -1:
                continue
            
            k = mask.bit_count()
            if k == len(nums):
                ans = max(ans, dp[mask])
                continue
            
            num = nums[k]
            available = ((1 << m) - 1) ^ mask
            
            while available:
                bit = available & -available
                i = bit.bit_length() - 1
                new_mask = mask | bit
                dp[new_mask] = max(dp[new_mask], dp[mask] + (num & slot[i]))
                available -= bit
        
        return ans
