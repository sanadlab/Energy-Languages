from typing import List
from collections import Counter

class Solution:
    def recoverArray(self, n: int, sums: List[int]) -> List[int]:
        sums.sort()
        min_sum = sums[0]
        target = -min_sum
        
        shifted = [x - min_sum for x in sums]
        shifted.sort()
        
        nums = []
        cur = shifted
        
        for _ in range(n):
            x = cur[1]
            nums.append(x)
            
            cnt = Counter(cur)
            nxt = []
            for s in cur:
                if cnt[s] > 0:
                    cnt[s] -= 1
                    cnt[s + x] -= 1
                    nxt.append(s)
            cur = nxt
        
        mask_found = 0
        for mask in range(1 << n):
            total = 0
            for i in range(n):
                if mask >> i & 1:
                    total += nums[i]
            if total == target:
                mask_found = mask
                break
        
        ans = []
        for i, x in enumerate(nums):
            if mask_found >> i & 1:
                ans.append(-x)
            else:
                ans.append(x)
        
        return ans
