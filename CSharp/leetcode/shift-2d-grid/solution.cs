public class Solution {
    public IList<IList<int>> ShiftGrid(int[][] grid, int k) {
        int m = grid.Length;
        int n = m > 0 ? grid[0].Length : 0;
        int total = m * n;
        var result = new List<IList<int>>();
        for (int i = 0; i < m; i++) result.Add(new List<int>(new int[n]));
        if (total == 0) return result;
        k %= total;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int pos = i * n + j;
                int np = (pos + k) % total;
                result[np / n][np % n] = grid[i][j];
            }
        }
        return result;
    }
}
