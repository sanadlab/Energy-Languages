class Solution {
public:
    vector<int> parent;
    int find(int x) {
        while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    }
    void uni(int a, int b) {
        int ra = find(a), rb = find(b);
        if (ra != rb) parent[ra] = rb;
    }
    int regionsBySlashes(vector<string>& grid) {
        int n = grid.size();
        parent.resize(4 * n * n);
        for (int i = 0; i < 4 * n * n; i++) parent[i] = i;
        for (int r = 0; r < n; r++) {
            for (int c = 0; c < n; c++) {
                int base = 4 * (r * n + c);
                int top = base, right = base + 1, bottom = base + 2, left = base + 3;
                char ch = c < (int)grid[r].size() ? grid[r][c] : ' ';
                if (ch == '/') { uni(top, left); uni(right, bottom); }
                else if (ch == '\\') { uni(top, right); uni(left, bottom); }
                else { uni(top, right); uni(right, bottom); uni(bottom, left); }
                if (c + 1 < n) uni(right, 4 * (r * n + c + 1) + 3);
                if (r + 1 < n) uni(bottom, 4 * ((r + 1) * n + c));
            }
        }
        int cnt = 0;
        for (int i = 0; i < 4 * n * n; i++) if (find(i) == i) cnt++;
        return cnt;
    }
};
