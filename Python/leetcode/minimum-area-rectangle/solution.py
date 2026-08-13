from typing import List

class Solution:
    def minAreaRect(self, points: List[List[int]]) -> int:
        seen = set()
        n = len(points)
        for p in points:
            seen.add(p[0] * 50000 + p[1])
        best = float('inf')
        for i in range(n):
            x1, y1 = points[i][0], points[i][1]
            for j in range(i + 1, n):
                x2, y2 = points[j][0], points[j][1]
                if x1 != x2 and y1 != y2:
                    if (x1 * 50000 + y2) in seen and (x2 * 50000 + y1) in seen:
                        area = abs(x1 - x2) * abs(y1 - y2)
                        if area < best:
                            best = area
        return 0 if best == float('inf') else best
