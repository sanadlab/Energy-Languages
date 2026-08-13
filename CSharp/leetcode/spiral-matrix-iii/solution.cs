public class Solution {
    public int[][] SpiralMatrixIII(int rows, int cols, int rStart, int cStart) {
        int total = rows * cols;
        var res = new List<int[]>();
        int r = rStart, c = cStart;
        if (r >= 0 && r < rows && c >= 0 && c < cols) res.Add(new int[]{r, c});
        int[] dr = {0, 1, 0, -1};
        int[] dc = {1, 0, -1, 0};
        int step = 1, d = 0;
        while (res.Count < total) {
            for (int t = 0; t < 2; t++) {
                for (int s = 0; s < step; s++) {
                    r += dr[d % 4];
                    c += dc[d % 4];
                    if (r >= 0 && r < rows && c >= 0 && c < cols) res.Add(new int[]{r, c});
                }
                d++;
            }
            step++;
        }
        return res.ToArray();
    }
}
