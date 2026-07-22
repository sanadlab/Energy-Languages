from typing import List
from bisect import bisect_right


class Solution:
    def makeArrayIncreasing(self, arr1: List[int], arr2: List[int]) -> int:
        arr2 = sorted(set(arr2))
        dp = {-1: 0}

        for x in arr1:
            ndp = {}

            for prev, ops in dp.items():
                if x > prev:
                    ndp[x] = min(ndp.get(x, float("inf")), ops)

                idx = bisect_right(arr2, prev)
                if idx < len(arr2):
                    y = arr2[idx]
                    ndp[y] = min(ndp.get(y, float("inf")), ops + 1)

            if not ndp:
                return -1

            dp = ndp

        return min(dp.values())
