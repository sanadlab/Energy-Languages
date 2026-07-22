from typing import List

class Solution:
    def findKDistantIndices(self, nums: List[int], key: int, k: int) -> List[int]:
        n = len(nums)
        result = set()
        key_positions = [i for i, val in enumerate(nums) if val == key]
        
        for i in range(n):
            for j in key_positions:
                if abs(i - j) <= k:
                    result.add(i)
                    break
        
        return sorted(result)
