public class Solution {
    public int CountGoodRectangles(int[][] rectangles) {
        int maxLen = 0, count = 0;
        foreach (var r in rectangles) {
            int side = Math.Min(r[0], r[1]);
            if (side > maxLen) { maxLen = side; count = 1; }
            else if (side == maxLen) { count++; }
        }
        return count;
    }
}
