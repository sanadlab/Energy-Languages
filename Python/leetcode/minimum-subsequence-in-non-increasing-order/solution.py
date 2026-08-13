from typing import List

class Solution:
    def minSubsequence(self, nums: List[int]) -> List[int]:
        nums.sort(reverse=True)
        total = sum(nums)
        running = 0
        res = []
        for x in nums:
            running += x
            res.append(x)
            if running * 2 > total:
                break
        return res
