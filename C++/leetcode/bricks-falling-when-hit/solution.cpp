class Solution {
    int m, n;
    vector<int> parent, sz;

    int find(int x) {
        while (parent[x] != x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    }

    void unite(int a, int b) {
        int ra = find(a), rb = find(b);
        if (ra == rb) return;
        if (sz[ra] < sz[rb]) swap(ra, rb);
        parent[rb] = ra;
        sz[ra] += sz[rb];
    }

    bool inb(int r, int c) {
        return r >= 0 && r < m && c >= 0 && c < n;
    }

public:
    vector<int> hitBricks(vector<vector<int>>& grid, vector<vector<int>>& hits) {
        m = (int)grid.size();
        n = m > 0 ? (int)grid[0].size() : 0;
        int total = m * n, top = total;
        parent.resize(total + 1);
        sz.assign(total + 1, 1);
        for (int i = 0; i <= total; i++) parent[i] = i;

        vector<vector<int>> g(m, vector<int>(n, 0));
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n && c < (int)grid[r].size(); c++)
                if (grid[r][c] == 1) g[r][c] = 1;

        for (auto& h : hits) {
            if ((int)h.size() < 2) continue;
            int r = h[0], c = h[1];
            if (inb(r, c)) g[r][c] = 0;
        }

        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (g[r][c] == 1) {
                    int cur = r * n + c;
                    if (r == 0) unite(cur, top);
                    if (r > 0 && g[r - 1][c] == 1) unite(cur, (r - 1) * n + c);
                    if (c > 0 && g[r][c - 1] == 1) unite(cur, r * n + c - 1);
                }

        int dirs[4][2] = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        vector<int> res(hits.size(), 0);
        for (int i = (int)hits.size() - 1; i >= 0; i--) {
            if ((int)hits[i].size() < 2) continue;
            int r = hits[i][0], c = hits[i][1];
            if (!inb(r, c)) continue;
            if (grid[r][c] != 1) continue;
            int before = sz[find(top)];
            g[r][c] = 1;
            int cur = r * n + c;
            if (r == 0) unite(cur, top);
            for (auto& d : dirs) {
                int nr = r + d[0], nc = c + d[1];
                if (inb(nr, nc) && g[nr][nc] == 1) unite(cur, nr * n + nc);
            }
            int after = sz[find(top)];
            int fallen = after - before - 1;
            res[i] = fallen > 0 ? fallen : 0;
        }
        return res;
    }
};
