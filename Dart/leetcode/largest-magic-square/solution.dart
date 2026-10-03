class Solution {
  int largestMagicSquare(List<List<int>> grid) {
    final int m = grid.length;
    final int n = grid[0].length;

    bool isMagicSquare(int r, int c, int k) {
      int total = 0;
      for (int j = c; j < c + k; j++) {
        total += grid[r + k - 1][j];
      }
      for (int i = 0; i < k; i++) {
        int rowSum = 0;
        int colSum = 0;
        for (int j = 0; j < k; j++) {
          rowSum += grid[r + i][c + j];
          colSum += grid[r + j][c + i];
        }
        if (rowSum != total || colSum != total) {
          return false;
        }
      }
      int diag1 = 0;
      int diag2 = 0;
      for (int i = 0; i < k; i++) {
        diag1 += grid[r + i][c + i];
        diag2 += grid[r + k - 1 - i][c + i];
      }
      return diag1 == total && diag2 == total;
    }

    final int maxK = m < n ? m : n;
    for (int k = maxK; k > 1; k--) {
      for (int i = 0; i <= m - k; i++) {
        for (int j = 0; j <= n - k; j++) {
          if (isMagicSquare(i, j, k)) {
            return k;
          }
        }
      }
    }

    return 1;
  }
}
