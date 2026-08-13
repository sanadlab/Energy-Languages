import java.util.*;

class Solution {
    public List<List<Integer>> shiftGrid(int[][] grid, int k) {
        int m = grid.length;
        int n = m > 0 ? grid[0].length : 0;
        int total = m * n;
        List<List<Integer>> result = new ArrayList<>();
        for (int i = 0; i < m; i++) {
            List<Integer> row = new ArrayList<>();
            for (int j = 0; j < n; j++) row.add(0);
            result.add(row);
        }
        if (total == 0) return result;
        k %= total;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                int pos = i * n + j;
                int np = (pos + k) % total;
                result.get(np / n).set(np % n, grid[i][j]);
            }
        }
        return result;
    }
}
