from typing import List

class Solution:
    def minSkips(self, dist: List[int], speed: int, hoursBefore: int) -> int:
        n = len(dist)
        limit = hoursBefore * speed
        INF = 10**30

        dp = [INF] * n
        dp[0] = 0

        for i in range(n - 1):
            ndp = [INF] * n
            for skips in range(i + 1):
                if dp[skips] == INF:
                    continue

                time_after_road = dp[skips] + dist[i]

                ndp[skips] = min(
                    ndp[skips],
                    ((time_after_road + speed - 1) // speed) * speed
                )

                ndp[skips + 1] = min(
                    ndp[skips + 1],
                    time_after_road
                )

            dp = ndp

        for skips in range(n):
            if dp[skips] + dist[-1] <= limit:
                return skips

        return -1
