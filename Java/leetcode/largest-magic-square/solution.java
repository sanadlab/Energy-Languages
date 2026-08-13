class Solution {
    public int largestMagicSquare(int[][] grid) {
        int m = grid.length;
        if (m == 0) return 0;
        int n = grid[0].length;
        int maxK = Math.min(m, n);
        for (int k = maxK; k >= 1; k--) {
            for (int i = 0; i + k <= m; i++) {
                for (int j = 0; j + k <= n; j++) {
                    if (isMagic(grid, i, j, k)) return k;
                }
            }
        }
        return 1;
    }

    private boolean isMagic(int[][] grid, int r, int c, int k) {
        int target = 0;
        for (int j = 0; j < k; j++) target += grid[r][c + j];
        for (int i = 0; i < k; i++) {
            int s = 0;
            for (int j = 0; j < k; j++) s += grid[r + i][c + j];
            if (s != target) return false;
        }
        for (int j = 0; j < k; j++) {
            int s = 0;
            for (int i = 0; i < k; i++) s += grid[r + i][c + j];
            if (s != target) return false;
        }
        int d1 = 0, d2 = 0;
        for (int i = 0; i < k; i++) {
            d1 += grid[r + i][c + i];
            d2 += grid[r + i][c + k - 1 - i];
        }
        return d1 == target && d2 == target;
    }
}
