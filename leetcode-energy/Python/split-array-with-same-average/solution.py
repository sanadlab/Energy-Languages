from typing import List

class Solution:
    def splitArraySameAverage(self, nums: List[int]) -> bool:
        n = len(nums)
        total = sum(nums)
        half = n // 2

        candidates = []
        for k in range(1, half + 1):
            if (total * k) % n == 0:
                candidates.append((k, (total * k) // n))

        if not candidates:
            return False

        dp = [0] * (half + 1)
        dp[0] = 1

        for i, x in enumerate(nums, 1):
            for k in range(min(i, half), 0, -1):
                dp[k] |= dp[k - 1] << x

        for k, target in candidates:
            if (dp[k] >> target) & 1:
                return True

        return False
