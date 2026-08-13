public class Solution {
    public bool CheckStraightLine(int[][] coordinates) {
        int x0 = coordinates[0][0], y0 = coordinates[0][1];
        int x1 = coordinates[1][0], y1 = coordinates[1][1];
        int dx = x1 - x0;
        int dy = y1 - y0;
        
        for (int i = 2; i < coordinates.Length; i++) {
            int x = coordinates[i][0], y = coordinates[i][1];
            // Check if the slope between (x0,y0) and (x,y) is the same as slope between (x0,y0) and (x1,y1)
            // To avoid floating point precision issues, use cross multiplication:
            // (y - y0) * dx == (x - x0) * dy
            if ((y - y0) * dx != (x - x0) * dy) {
                return false;
            }
        }
        return true;
    }
}