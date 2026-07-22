from typing import List
import math

class Solution:
    def numPoints(self, darts: List[List[int]], r: int) -> int:
        n = len(darts)
        if n <= 1:
            return n

        ans = 1
        eps = 1e-7

        def count(cx: float, cy: float) -> int:
            res = 0
            for x, y in darts:
                if math.hypot(x - cx, y - cy) <= r + eps:
                    res += 1
            return res

        for i in range(n):
            x1, y1 = darts[i]
            for j in range(i + 1, n):
                x2, y2 = darts[j]
                dx = x2 - x1
                dy = y2 - y1
                d2 = dx * dx + dy * dy
                d = math.sqrt(d2)

                if d > 2 * r + eps:
                    continue

                mx = (x1 + x2) / 2.0
                my = (y1 + y2) / 2.0

                h = math.sqrt(max(0.0, r * r - d2 / 4.0))

                ux = -dy / d
                uy = dx / d

                c1x = mx + ux * h
                c1y = my + uy * h
                c2x = mx - ux * h
                c2y = my - uy * h

                ans = max(ans, count(c1x, c1y), count(c2x, c2y))

                if ans == n:
                    return n

        return ans
