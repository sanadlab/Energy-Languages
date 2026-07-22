from typing import List
from collections import Counter, defaultdict

class Solution:
    def waysToPartition(self, nums: List[int], k: int) -> int:
        n = len(nums)
        total = sum(nums)
        
        diffs = []
        prefix = 0
        for i in range(n - 1):
            prefix += nums[i]
            diffs.append(2 * prefix - total)
        
        right = Counter(diffs)
        left = defaultdict(int)
        
        ans = right[0]
        
        for i in range(n):
            delta = k - nums[i]
            ans = max(ans, left[delta] + right[-delta])
            
            if i < n - 1:
                diff = diffs[i]
                right[diff] -= 1
                left[diff] += 1
        
        return ans
