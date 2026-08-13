public class Solution {
    private int[] parent;
    private int[] sz;

    private int Find(int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }

    private void Union(int a, int b) {
        int ra = Find(a), rb = Find(b);
        if (ra == rb) return;
        if (sz[ra] < sz[rb]) { int t = ra; ra = rb; rb = t; }
        parent[rb] = ra;
        sz[ra] += sz[rb];
    }

    public int[] HitBricks(int[][] grid, int[][] hits) {
        int m = grid.Length;
        int n = m > 0 ? grid[0].Length : 0;
        int total = m * n, top = total;
        parent = new int[total + 1];
        sz = new int[total + 1];
        for (int i = 0; i <= total; i++) { parent[i] = i; sz[i] = 1; }

        int[][] g = new int[m][];
        for (int r = 0; r < m; r++) {
            g[r] = new int[n];
            for (int c = 0; c < n && c < grid[r].Length; c++)
                if (grid[r][c] == 1) g[r][c] = 1;
        }

        foreach (var h in hits) {
            if (h.Length < 2) continue;
            int r = h[0], c = h[1];
            if (r >= 0 && r < m && c >= 0 && c < n) g[r][c] = 0;
        }

        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (g[r][c] == 1) {
                    int cur = r * n + c;
                    if (r == 0) Union(cur, top);
                    if (r > 0 && g[r - 1][c] == 1) Union(cur, (r - 1) * n + c);
                    if (c > 0 && g[r][c - 1] == 1) Union(cur, r * n + c - 1);
                }

        int[][] dirs = new int[][] {
            new int[]{1, 0}, new int[]{-1, 0}, new int[]{0, 1}, new int[]{0, -1}
        };
        int[] res = new int[hits.Length];
        for (int i = hits.Length - 1; i >= 0; i--) {
            if (hits[i].Length < 2) continue;
            int r = hits[i][0], c = hits[i][1];
            if (r < 0 || r >= m || c < 0 || c >= n) continue;
            if (grid[r][c] != 1) continue;
            int before = sz[Find(top)];
            g[r][c] = 1;
            int cur = r * n + c;
            if (r == 0) Union(cur, top);
            foreach (var d in dirs) {
                int nr = r + d[0], nc = c + d[1];
                if (nr >= 0 && nr < m && nc >= 0 && nc < n && g[nr][nc] == 1)
                    Union(cur, nr * n + nc);
            }
            int after = sz[Find(top)];
            int f = after - before - 1;
            res[i] = f > 0 ? f : 0;
        }
        return res;
    }
}
