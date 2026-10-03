#include <stdlib.h>
#include <string.h>

static int rbs_find(int* parent, int x) {
    while (parent[x] != x) {
        parent[x] = parent[parent[x]];
        x = parent[x];
    }
    return x;
}

static void rbs_union(int* parent, int a, int b) {
    int ra = rbs_find(parent, a), rb = rbs_find(parent, b);
    if (ra != rb) parent[ra] = rb;
}

int regionsBySlashes(char** grid, int gridSize) {
    int n = gridSize;
    int N = 4 * n * n;
    int* parent = malloc((size_t)N * sizeof(int));
    for (int i = 0; i < N; i++) parent[i] = i;

    for (int r = 0; r < n; r++) {
        char* row = grid[r];
        int rowlen = (int)strlen(row);
        for (int c = 0; c < n; c++) {
            int base = 4 * (r * n + c);
            int top = base, right = base + 1, bottom = base + 2, left = base + 3;
            char ch = (c < rowlen) ? row[c] : ' ';
            if (ch == '/') {
                rbs_union(parent, top, left);
                rbs_union(parent, right, bottom);
            } else if (ch == '\\') {
                rbs_union(parent, top, right);
                rbs_union(parent, left, bottom);
            } else {
                rbs_union(parent, top, right);
                rbs_union(parent, right, bottom);
                rbs_union(parent, bottom, left);
            }
            if (c + 1 < n) rbs_union(parent, right, 4 * (r * n + c + 1) + 3);
            if (r + 1 < n) rbs_union(parent, bottom, 4 * ((r + 1) * n + c));
        }
    }

    int count = 0;
    for (int i = 0; i < N; i++) if (rbs_find(parent, i) == i) count++;
    free(parent);
    return count;
}
