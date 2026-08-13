from math import gcd


class Solution:
    def maxPoints(self, points):
        n = len(points)
        if n <= 2:
            return n
        best = 1
        for i in range(n):
            slopes = {}
            for j in range(i + 1, n):
                dx = points[j][0] - points[i][0]
                dy = points[j][1] - points[i][1]
                g = gcd(abs(dx), abs(dy))
                dx //= g
                dy //= g
                if dx < 0 or (dx == 0 and dy < 0):
                    dx, dy = -dx, -dy
                key = (dx, dy)
                slopes[key] = slopes.get(key, 0) + 1
                if slopes[key] + 1 > best:
                    best = slopes[key] + 1
        return best
