from math import gcd
from collections import defaultdict

class Solution:
    def maxPoints(self, points: list[list[int]]) -> int:
        if len(points) <= 2:
            return len(points)
        
        max_points = 1
        
        for i in range(len(points)):
            slopes = defaultdict(int)
            same_points = 0
            cur_max = 0
            x1, y1 = points[i]
            
            for j in range(i + 1, len(points)):
                x2, y2 = points[j]
                dx = x2 - x1
                dy = y2 - y1
                
                if dx == 0 and dy == 0:
                    same_points += 1
                    continue
                
                g = gcd(dy, dx)
                if g != 0:
                    dy //= g
                    dx //= g
                
                # Normalize slope direction: keep dx positive or if dx=0 keep dy positive
                if dx < 0:
                    dx = -dx
                    dy = -dy
                elif dx == 0:
                    dy = 1
                
                slopes[(dy, dx)] += 1
                cur_max = max(cur_max, slopes[(dy, dx)])
            
            max_points = max(max_points, cur_max + same_points + 1)
        
        return max_points
