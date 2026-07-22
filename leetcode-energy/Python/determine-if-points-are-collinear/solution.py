from typing import List

class Solution:
    def checkStraightLine(self, coordinates: List[List[int]]) -> bool:
        x0, y0 = coordinates[0]
        x1, y1 = coordinates[1]
        
        # Calculate the differences for the first two points
        dx = x1 - x0
        dy = y1 - y0
        
        for i in range(2, len(coordinates)):
            x, y = coordinates[i]
            # Check if the cross product of vectors (x1-x0, y1-y0) and (x-x0, y-y0) is zero
            # cross product = dx*(y - y0) - dy*(x - x0)
            if dx * (y - y0) != dy * (x - x0):
                return False
        return True
