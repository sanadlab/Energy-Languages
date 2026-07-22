from typing import List

class Solution:
    def maxSizeSlices(self, slices: List[int]) -> int:
        picks = len(slices) // 3

        def best_linear(arr: List[int]) -> int:
            m = len(arr)
            neg = -10**9
            dp = [[neg] * (picks + 1) for _ in range(m + 1)]
            dp[0][0] = 0

            for i in range(1, m + 1):
                dp[i][0] = 0
                for j in range(1, picks + 1):
                    dp[i][j] = dp[i - 1][j]

                    if i == 1:
                        if j == 1:
                            dp[i][j] = max(dp[i][j], arr[i - 1])
                    else:
                        dp[i][j] = max(dp[i][j], dp[i - 2][j - 1] + arr[i - 1])

            return dp[m][picks]

        return max(best_linear(slices[:-1]), best_linear(slices[1:]))
