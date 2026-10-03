class Solution {
  late List<int> parent;
  late List<int> size;

  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]];
      x = parent[x];
    }
    return x;
  }

  void union(int a, int b) {
    int ra = find(a);
    int rb = find(b);
    if (ra == rb) return;
    if (size[ra] < size[rb]) {
      int t = ra;
      ra = rb;
      rb = t;
    }
    parent[rb] = ra;
    size[ra] += size[rb];
  }

  List<int> hitBricks(List<List<int>> grid, List<List<int>> hits) {
    int m = grid.length;
    int n = m > 0 ? grid[0].length : 0;
    int total = m * n;
    int top = total;
    parent = List<int>.generate(total + 1, (i) => i);
    size = List<int>.filled(total + 1, 1);

    bool inBounds(int r, int c) => r >= 0 && r < m && c >= 0 && c < n;

    // working grid: 1 where a brick currently stands
    List<List<int>> g = List.generate(m, (_) => List<int>.filled(n, 0));
    for (int r = 0; r < m; r++) {
      for (int c = 0; c < n; c++) {
        if (grid[r][c] == 1) g[r][c] = 1;
      }
    }

    // erase the hit bricks up-front
    for (var h in hits) {
      if (h.length >= 2 && inBounds(h[0], h[1])) {
        g[h[0]][h[1]] = 0;
      }
    }

    // build union-find over the bricks that remain
    for (int r = 0; r < m; r++) {
      for (int c = 0; c < n; c++) {
        if (g[r][c] == 1) {
          int cur = r * n + c;
          if (r == 0) union(cur, top);
          if (r > 0 && g[r - 1][c] == 1) union(cur, (r - 1) * n + c);
          if (c > 0 && g[r][c - 1] == 1) union(cur, r * n + c - 1);
        }
      }
    }

    const List<List<int>> dirs = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1]
    ];
    List<int> result = List<int>.filled(hits.length, 0);
    for (int i = hits.length - 1; i >= 0; i--) {
      var h = hits[i];
      if (h.length < 2) continue;
      int r = h[0];
      int c = h[1];
      if (!inBounds(r, c)) continue;
      // only a brick that originally existed there can fall back into place
      if (!(c < grid[r].length && grid[r][c] == 1)) continue;
      int before = size[find(top)];
      g[r][c] = 1;
      int cur = r * n + c;
      if (r == 0) union(cur, top);
      for (var d in dirs) {
        int nr = r + d[0];
        int nc = c + d[1];
        if (inBounds(nr, nc) && g[nr][nc] == 1) union(cur, nr * n + nc);
      }
      int after = size[find(top)];
      int diff = after - before - 1;
      result[i] = diff > 0 ? diff : 0;
    }
    return result;
  }
}
