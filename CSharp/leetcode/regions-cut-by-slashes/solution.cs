public class Solution {
    int[] parent;
    int Find(int x) {
        while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    }
    void Union(int a, int b) {
        int ra = Find(a), rb = Find(b);
        if (ra != rb) parent[ra] = rb;
    }
    public int RegionsBySlashes(string[] grid) {
        int n = grid.Length;
        parent = new int[4 * n * n];
        for (int i = 0; i < 4 * n * n; i++) parent[i] = i;
        for (int r = 0; r < n; r++) {
            for (int c = 0; c < n; c++) {
                int b = 4 * (r * n + c);
                int top = b, right = b + 1, bottom = b + 2, left = b + 3;
                char ch = c < grid[r].Length ? grid[r][c] : ' ';
                if (ch == '/') { Union(top, left); Union(right, bottom); }
                else if (ch == '\\') { Union(top, right); Union(left, bottom); }
                else { Union(top, right); Union(right, bottom); Union(bottom, left); }
                if (c + 1 < n) Union(right, 4 * (r * n + c + 1) + 3);
                if (r + 1 < n) Union(bottom, 4 * ((r + 1) * n + c));
            }
        }
        int cnt = 0;
        for (int i = 0; i < 4 * n * n; i++) if (Find(i) == i) cnt++;
        return cnt;
    }
}
