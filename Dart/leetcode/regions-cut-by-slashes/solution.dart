class Solution {
  int regionsBySlashes(List<String> grid) {
    final n = grid.length;
    final parent = List<int>.generate(4 * n * n, (i) => i);

    int find(int x) {
      while (parent[x] != x) {
        parent[x] = parent[parent[x]];
        x = parent[x];
      }
      return x;
    }

    void union(int a, int b) {
      final ra = find(a), rb = find(b);
      if (ra != rb) {
        parent[ra] = rb;
      }
    }

    for (var r = 0; r < n; r++) {
      final row = grid[r];
      for (var c = 0; c < n; c++) {
        final base = 4 * (r * n + c);
        final top = base, right = base + 1, bottom = base + 2, left = base + 3;
        final ch = c < row.length ? row[c] : ' ';
        if (ch == '/') {
          union(top, left);
          union(right, bottom);
        } else if (ch == '\\') {
          union(top, right);
          union(left, bottom);
        } else {
          union(top, right);
          union(right, bottom);
          union(bottom, left);
        }
        if (c + 1 < n) {
          union(right, 4 * (r * n + c + 1) + 3);
        }
        if (r + 1 < n) {
          union(bottom, 4 * ((r + 1) * n + c));
        }
      }
    }
    var count = 0;
    for (var i = 0; i < 4 * n * n; i++) {
      if (find(i) == i) count++;
    }
    return count;
  }
}
