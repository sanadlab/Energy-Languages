class Solution {
  List<List<int>> spiralMatrixIII(int rows, int cols, int rStart, int cStart) {
    int total = rows * cols;
    List<List<int>> res = [];
    int r = rStart;
    int c = cStart;
    if (0 <= r && r < rows && 0 <= c && c < cols) {
      res.add([r, c]);
    }
    List<int> dr = [0, 1, 0, -1];
    List<int> dc = [1, 0, -1, 0];
    int step = 1;
    int d = 0;
    while (res.length < total) {
      for (int t = 0; t < 2; t++) {
        for (int s = 0; s < step; s++) {
          r += dr[d % 4];
          c += dc[d % 4];
          if (0 <= r && r < rows && 0 <= c && c < cols) {
            res.add([r, c]);
          }
        }
        d += 1;
      }
      step += 1;
    }
    return res;
  }
}
