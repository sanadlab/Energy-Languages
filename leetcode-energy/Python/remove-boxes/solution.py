from typing import List
from functools import lru_cache


class Solution:
    def removeBoxes(self, boxes: List[int]) -> int:
        colors = []
        counts = []

        for x in boxes:
            if colors and colors[-1] == x:
                counts[-1] += 1
            else:
                colors.append(x)
                counts.append(1)

        n = len(colors)

        prev_same = [[] for _ in range(n)]
        seen = {}
        for i, c in enumerate(colors):
            prev_same[i] = seen.get(c, []).copy()
            seen.setdefault(c, []).append(i)

        @lru_cache(None)
        def dp(l: int, r: int, k: int) -> int:
            if l > r:
                return 0

            res = dp(l, r - 1, 0) + (counts[r] + k) * (counts[r] + k)

            same = prev_same[r]
            for idx in range(len(same) - 1, -1, -1):
                i = same[idx]
                if i < l:
                    break
                res = max(
                    res,
                    dp(l, i, k + counts[r]) + dp(i + 1, r - 1, 0)
                )

            return res

        return dp(0, n - 1, 0)
