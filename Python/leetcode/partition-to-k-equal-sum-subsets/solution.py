from typing import List


class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        if k <= 0 or len(nums) < k:
            return False
        total = sum(nums)
        if total % k != 0:
            return False
        target = total // k
        nums.sort(reverse=True)
        if nums[0] > target:
            return False
        n = len(nums)
        used = [False] * n

        def backtrack(k: int, cur: int, start: int) -> bool:
            if k == 0:
                return True
            if cur == target:
                return backtrack(k - 1, 0, 0)
            for i in range(start, n):
                if used[i] or cur + nums[i] > target:
                    continue
                used[i] = True
                if backtrack(k, cur + nums[i], i + 1):
                    return True
                used[i] = False
                if cur == 0:
                    break
            return False

        return backtrack(k, 0, 0)
