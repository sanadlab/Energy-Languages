from typing import List

class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        n = len(nums)
        dp = [{} for _ in range(n)]
        ans = 0

        for i in range(n):
            for j in range(i):
                diff = nums[i] - nums[j]
                count = dp[j].get(diff, 0)
                ans += count
                dp[i][diff] = dp[i].get(diff, 0) + count + 1

        return ans
