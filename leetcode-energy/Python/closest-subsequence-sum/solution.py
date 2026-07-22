from typing import List
from bisect import bisect_left

class Solution:
    def minAbsDifference(self, nums: List[int], goal: int) -> int:
        def subset_sums(arr):
            sums = [0]
            for x in arr:
                sums += [s + x for s in sums]
            return sums

        n = len(nums)
        left = subset_sums(nums[:n // 2])
        right = subset_sums(nums[n // 2:])
        right.sort()

        ans = abs(goal)

        for s in left:
            target = goal - s
            i = bisect_left(right, target)

            if i < len(right):
                ans = min(ans, abs(s + right[i] - goal))
                if ans == 0:
                    return 0

            if i > 0:
                ans = min(ans, abs(s + right[i - 1] - goal))
                if ans == 0:
                    return 0

        return ans
