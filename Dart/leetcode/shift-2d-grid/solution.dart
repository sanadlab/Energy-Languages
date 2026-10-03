class Solution {
  List<List<int>> shiftGrid(List<List<int>> grid, int k) {
    int m = grid.length;
    if (m == 0) {
      return grid;
    }
    int n = grid[0].length;
    if (n == 0) {
      return grid;
    }
    int total = m * n;
    k %= total;
    List<int> flat = [];
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        flat.add(grid[i][j]);
      }
    }
    List<List<int>> res =
        List.generate(m, (_) => List<int>.filled(n, 0));
    for (int idx = 0; idx < total; idx++) {
      int np = (idx + k) % total;
      res[np ~/ n][np % n] = flat[idx];
    }
    return res;
  }
}
