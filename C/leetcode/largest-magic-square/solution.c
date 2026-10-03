#include <stdbool.h>

static bool is_magic_square(int** grid, int r, int c, int k) {
    int total = 0;
    for (int j = 0; j < k; j++) total += grid[r + k - 1][c + j];
    for (int i = 0; i < k; i++) {
        int row_sum = 0, col_sum = 0;
        for (int j = 0; j < k; j++) {
            row_sum += grid[r + i][c + j];
            col_sum += grid[r + j][c + i];
        }
        if (row_sum != total || col_sum != total) return false;
    }
    int diag1 = 0, diag2 = 0;
    for (int i = 0; i < k; i++) {
        diag1 += grid[r + i][c + i];
        diag2 += grid[r + k - 1 - i][c + i];
    }
    return diag1 == total && diag2 == total;
}

int largestMagicSquare(int** grid, int gridSize, int* gridColSize) {
    int m = gridSize, n = gridColSize[0];
    int kmax = m < n ? m : n;
    for (int k = kmax; k > 1; k--) {
        for (int i = 0; i + k <= m; i++) {
            for (int j = 0; j + k <= n; j++) {
                if (is_magic_square(grid, i, j, k)) return k;
            }
        }
    }
    return 1;
}
