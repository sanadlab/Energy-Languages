class Solution {
    int[] parent;
    int find(int x) {
        while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    }
    void union(int a, int b) {
        int ra = find(a), rb = find(b);
        if (ra != rb) parent[ra] = rb;
    }
    public int regionsBySlashes(String[] grid) {
        int n = grid.length;
        parent = new int[4 * n * n];
        for (int i = 0; i < 4 * n * n; i++) parent[i] = i;
        for (int r = 0; r < n; r++) {
            for (int c = 0; c < n; c++) {
                int base = 4 * (r * n + c);
                int top = base, right = base + 1, bottom = base + 2, left = base + 3;
                char ch = c < grid[r].length() ? grid[r].charAt(c) : ' ';
                if (ch == '/') { union(top, left); union(right, bottom); }
                else if (ch == '\\') { union(top, right); union(left, bottom); }
                else { union(top, right); union(right, bottom); union(bottom, left); }
                if (c + 1 < n) union(right, 4 * (r * n + c + 1) + 3);
                if (r + 1 < n) union(bottom, 4 * ((r + 1) * n + c));
            }
        }
        int cnt = 0;
        for (int i = 0; i < 4 * n * n; i++) if (find(i) == i) cnt++;
        return cnt;
    }
}
