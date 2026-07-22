from typing import List
from math import gcd

class Solution:
    def countDifferentSubsequenceGCDs(self, nums: List[int]) -> int:
        max_num = max(nums)
        present = [False] * (max_num + 1)
        
        for num in nums:
            present[num] = True
        
        ans = 0
        
        for x in range(1, max_num + 1):
            g = 0
            
            for multiple in range(x, max_num + 1, x):
                if present[multiple]:
                    g = gcd(g, multiple)
                    
                    if g == x:
                        ans += 1
                        break
        
        return ans
