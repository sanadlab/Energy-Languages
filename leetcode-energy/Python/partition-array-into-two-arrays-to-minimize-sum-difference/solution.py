from typing import List
from bisect import bisect_left


class Solution:
    def minimumDifference(self, nums: List[int]) -> int:
        n = len(nums) // 2
        total = sum(nums)

        left = [[] for _ in range(n + 1)]
        right = [[] for _ in range(n + 1)]

        for mask in range(1 << n):
            cnt = mask.bit_count()
            left_sum = 0
            right_sum = 0

            for i in range(n):
                if mask & (1 << i):
                    left_sum += nums[i]
                    right_sum += nums[n + i]

            left[cnt].append(left_sum)
            right[cnt].append(2 * right_sum)

        for k in range(n + 1):
            right[k].sort()

        ans = float("inf")

        for left_count in range(n + 1):
            right_count = n - left_count
            right_sums = right[right_count]

            for left_sum in left[left_count]:
                target = total - 2 * left_sum
                idx = bisect_left(right_sums, target)

                if idx < len(right_sums):
                    ans = min(ans, abs(target - right_sums[idx]))
                if idx > 0:
                    ans = min(ans, abs(target - right_sums[idx - 1]))

                if ans == 0:
                    return 0

        return ans
