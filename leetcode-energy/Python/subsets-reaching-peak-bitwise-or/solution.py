from typing import List

class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        max_or = 0
        for num in nums:
            max_or |= num
        
        count = 0
        
        def backtrack(i, cur_or):
            nonlocal count
            if i == len(nums):
                if cur_or == max_or and cur_or != 0:
                    count += 1
                return
            # Include nums[i]
            backtrack(i+1, cur_or | nums[i])
            # Exclude nums[i]
            backtrack(i+1, cur_or)
        
        backtrack(0, 0)
        return count
