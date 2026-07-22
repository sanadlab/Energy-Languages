from typing import List
from bisect import bisect_left, bisect_right

class Solution:
    def stoneGameV(self, stoneValue: List[int]) -> int:
        n = len(stoneValue)
        if n <= 1:
            return 0

        prefix = [0] * (n + 1)
        for i, v in enumerate(stoneValue):
            prefix[i + 1] = prefix[i] + v

        dp = [[0] * n for _ in range(n)]
        leftBest = [[0] * n for _ in range(n)]
        rightBest = [[0] * n for _ in range(n)]

        for i, v in enumerate(stoneValue):
            leftBest[i][i] = v
            rightBest[i][i] = v

        for length in range(2, n + 1):
            for i in range(n - length + 1):
                j = i + length - 1
                total = prefix[j + 1] - prefix[i]
                target = prefix[i] + prefix[j + 1]
                best = 0

                x_last = bisect_right(prefix, (target - 1) // 2, i + 1, j + 1) - 1
                if x_last >= i + 1:
                    best = max(best, leftBest[i][x_last - 1])

                m_first = bisect_left(prefix, target // 2 + 1, i + 1, j + 1)
                if m_first <= j:
                    best = max(best, rightBest[m_first][j])

                if target % 2 == 0:
                    mid = target // 2
                    x = bisect_left(prefix, mid, i + 1, j + 1)
                    if x <= j and prefix[x] == mid:
                        best = max(best, total // 2 + max(dp[i][x - 1], dp[x][j]))

                dp[i][j] = best
                value = total + best
                leftBest[i][j] = max(leftBest[i][j - 1], value)
                rightBest[i][j] = max(rightBest[i + 1][j], value)

        return dp[0][n - 1]
