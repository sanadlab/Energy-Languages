from typing import List

class Solution:
    def minimumFinishTime(self, tires: List[List[int]], changeTime: int, numLaps: int) -> int:
        INF = 10**30
        best = [INF] * (numLaps + 1)
        max_len = 0

        for f, r in tires:
            lap_time = f
            total = 0
            laps = 1

            while laps <= numLaps and lap_time <= changeTime + f:
                total += lap_time
                if total < best[laps]:
                    best[laps] = total
                max_len = max(max_len, laps)
                lap_time *= r
                laps += 1

        dp = [INF] * (numLaps + 1)
        dp[0] = -changeTime

        for i in range(1, numLaps + 1):
            for k in range(1, min(i, max_len) + 1):
                dp[i] = min(dp[i], dp[i - k] + changeTime + best[k])

        return dp[numLaps]
