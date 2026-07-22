from typing import List
from functools import lru_cache

class Solution:
    def countRoutes(self, locations: List[int], start: int, finish: int, fuel: int) -> int:
        MOD = 10 ** 9 + 7
        n = len(locations)

        @lru_cache(None)
        def dp(city: int, remaining: int) -> int:
            if abs(locations[city] - locations[finish]) > remaining:
                return 0

            routes = 1 if city == finish else 0

            for nxt in range(n):
                if nxt == city:
                    continue

                cost = abs(locations[city] - locations[nxt])
                if cost <= remaining:
                    routes += dp(nxt, remaining - cost)
                    routes %= MOD

            return routes

        return dp(start, fuel)
