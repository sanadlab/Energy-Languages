int** shiftGrid(int** grid, int gridSize, int* gridColSize, int k, int* returnSize, int** returnColumnSizes) {
    int m = gridSize, n = gridColSize[0], total = m * n;
    k %= total;
    int** res = malloc(m * sizeof(int*));
    *returnColumnSizes = malloc(m * sizeof(int));
    for (int i = 0; i < m; i++) { res[i] = malloc(n * sizeof(int)); (*returnColumnSizes)[i] = n; }
    for (int i = 0; i < total; i++) { int ni = (i + k) % total; res[ni / n][ni % n] = grid[i / n][i % n]; }
    *returnSize = m;
    return res;
}
