from typing import List

class Solution:
    def countGoodRectangles(self, rectangles: List[List[int]]) -> int:
        max_len = 0
        count = 0
        
        for l, w in rectangles:
            side = min(l, w)
            if side > max_len:
                max_len = side
                count = 1
            elif side == max_len:
                count += 1
        
        return count
