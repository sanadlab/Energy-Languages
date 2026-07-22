from typing import List

class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        vals = [1] + [x for x in nums if x > 0] + [1]
        m = len(vals)
        dp = [[0] * m for _ in range(m)]

        for length in range(2, m):
            for left in range(m - length):
                right = left + length
                best = 0
                base = vals[left] * vals[right]
                dp_left = dp[left]

                for k in range(left + 1, right):
                    coins = dp_left[k] + dp[k][right] + base * vals[k]
                    if coins > best:
                        best = coins

                dp_left[right] = best

        return dp[0][m - 1]
