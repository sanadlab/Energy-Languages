from typing import List

class Solution:
    def minCost(self, houses: List[int], cost: List[List[int]], m: int, n: int, target: int) -> int:
        INF = 10**15

        dp = [[INF] * (target + 1) for _ in range(n)]

        if houses[0] != 0:
            dp[houses[0] - 1][1] = 0
        else:
            for c in range(n):
                dp[c][1] = cost[0][c]

        for i in range(1, m):
            ndp = [[INF] * (target + 1) for _ in range(n)]

            if houses[i] != 0:
                colors = [houses[i] - 1]
            else:
                colors = range(n)

            for c in colors:
                paint_cost = 0 if houses[i] != 0 else cost[i][c]

                for pc in range(n):
                    diff = 1 if c != pc else 0

                    for k in range(1, target + 1):
                        nk = k + diff
                        if nk <= target and dp[pc][k] != INF:
                            ndp[c][nk] = min(ndp[c][nk], dp[pc][k] + paint_cost)

            dp = ndp

        ans = min(dp[c][target] for c in range(n))
        return -1 if ans == INF else ans
