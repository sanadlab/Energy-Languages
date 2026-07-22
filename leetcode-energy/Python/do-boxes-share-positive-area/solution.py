class Solution:
    def isRectangleOverlap(self, rec1: list[int], rec2: list[int]) -> bool:
        # Two rectangles do not overlap if one is completely to the left,
        # right, above, or below the other.
        # So, they overlap if:
        # rec1's left edge < rec2's right edge
        # rec1's right edge > rec2's left edge
        # rec1's bottom edge < rec2's top edge
        # rec1's top edge > rec2's bottom edge
        
        return (rec1[0] < rec2[2] and
                rec1[2] > rec2[0] and
                rec1[1] < rec2[3] and
                rec1[3] > rec2[1])
