from typing import List

class Solution:
    def minCost(self, n: int, cuts: List[int]) -> int:
        points = [0] + sorted(cuts) + [n]
        m = len(points)
        dp = [[0] * m for _ in range(m)]

        for length in range(2, m):
            for i in range(m - length):
                j = i + length
                dp[i][j] = min(
                    dp[i][k] + dp[k][j] + points[j] - points[i]
                    for k in range(i + 1, j)
                )

        return dp[0][m - 1]
