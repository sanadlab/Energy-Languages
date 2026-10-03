/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
static int uf_find(int* parent, int x) {
    while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
    return x;
}

static void uf_union(int* parent, int* sz, int a, int b) {
    int ra = uf_find(parent, a), rb = uf_find(parent, b);
    if (ra == rb) return;
    if (sz[ra] < sz[rb]) { int t = ra; ra = rb; rb = t; }
    parent[rb] = ra;
    sz[ra] += sz[rb];
}

int* hitBricks(int** grid, int gridSize, int* gridColSize, int** hits, int hitsSize, int* hitsColSize, int* returnSize) {
    int m = gridSize;
    int n = (m && gridColSize) ? gridColSize[0] : 0;
    int total = m * n;
    int top = total;

    int* parent = (int*) malloc(sizeof(int) * (total + 1));
    int* sz = (int*) malloc(sizeof(int) * (total + 1));
    for (int i = 0; i <= total; i++) { parent[i] = i; sz[i] = 1; }

    int* g = (int*) calloc(total > 0 ? total : 1, sizeof(int));
    for (int r = 0; r < m; r++)
        for (int c = 0; c < n; c++)
            if (grid[r][c] == 1) g[r * n + c] = 1;

    for (int h = 0; h < hitsSize; h++) {
        int r = hits[h][0], c = hits[h][1];
        if (r >= 0 && r < m && c >= 0 && c < n) g[r * n + c] = 0;
    }

    for (int r = 0; r < m; r++)
        for (int c = 0; c < n; c++)
            if (g[r * n + c] == 1) {
                int cur = r * n + c;
                if (r == 0) uf_union(parent, sz, cur, top);
                if (r > 0 && g[(r - 1) * n + c] == 1) uf_union(parent, sz, cur, (r - 1) * n + c);
                if (c > 0 && g[r * n + c - 1] == 1) uf_union(parent, sz, cur, r * n + c - 1);
            }

    int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    int* result = (int*) calloc(hitsSize > 0 ? hitsSize : 1, sizeof(int));
    for (int i = hitsSize - 1; i >= 0; i--) {
        int r = hits[i][0], c = hits[i][1];
        if (!(r >= 0 && r < m && c >= 0 && c < n)) continue;
        if (grid[r][c] != 1) continue;          /* only originally-present bricks can fall back */
        int before = sz[uf_find(parent, top)];
        g[r * n + c] = 1;
        int cur = r * n + c;
        if (r == 0) uf_union(parent, sz, cur, top);
        for (int d = 0; d < 4; d++) {
            int nr = r + dirs[d][0], nc = c + dirs[d][1];
            if (nr >= 0 && nr < m && nc >= 0 && nc < n && g[nr * n + nc] == 1)
                uf_union(parent, sz, cur, nr * n + nc);
        }
        int after = sz[uf_find(parent, top)];
        int diff = after - before - 1;
        result[i] = diff > 0 ? diff : 0;
    }

    *returnSize = hitsSize;
    free(parent); free(sz); free(g);
    return result;
}
