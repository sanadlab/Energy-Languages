class Solution:
    def countGoodRectangles(self, rectangles):
        max_len = 0
        count = 0
        for r in rectangles:
            side = min(r[0], r[1])
            if side > max_len:
                max_len = side
                count = 1
            elif side == max_len:
                count += 1
        return count
