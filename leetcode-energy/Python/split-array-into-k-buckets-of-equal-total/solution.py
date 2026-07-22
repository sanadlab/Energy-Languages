from typing import List

class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        total_sum = sum(nums)
        if total_sum % k != 0:
            return False
        target = total_sum // k
        nums.sort(reverse=True)
        if nums[0] > target:
            return False
        
        used = [False] * len(nums)
        
        def backtrack(start, k, current_sum):
            if k == 0:
                return True
            if current_sum == target:
                return backtrack(0, k-1, 0)
            
            for i in range(start, len(nums)):
                if not used[i] and current_sum + nums[i] <= target:
                    used[i] = True
                    if backtrack(i+1, k, current_sum + nums[i]):
                        return True
                    used[i] = False
                    # Optimization: if current_sum is 0 and nums[i] didn't fit, no need to try others at this level
                    if current_sum == 0:
                        break
            return False
        
        return backtrack(0, k, 0)
