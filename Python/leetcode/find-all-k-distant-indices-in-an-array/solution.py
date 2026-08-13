from typing import List

class Solution:
    def findKDistantIndices(self, nums: List[int], key: int, k: int) -> List[int]:
        result = []
        for i in range(len(nums)):
            if any(abs(i - j) <= k and nums[j] == key for j in range(len(nums))):
                result.append(i)
        return result