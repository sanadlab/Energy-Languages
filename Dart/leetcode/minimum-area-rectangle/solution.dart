class Solution {
  int minAreaRect(List<List<int>> points) {
    Set<int> seen = {};
    int n = points.length;
    for (List<int> p in points) {
      seen.add(p[0] * 50000 + p[1]);
    }
    int best = 1 << 62;
    for (int i = 0; i < n; i++) {
      int x1 = points[i][0], y1 = points[i][1];
      for (int j = i + 1; j < n; j++) {
        int x2 = points[j][0], y2 = points[j][1];
        if (x1 != x2 && y1 != y2) {
          if (seen.contains(x1 * 50000 + y2) && seen.contains(x2 * 50000 + y1)) {
            int area = (x1 - x2).abs() * (y1 - y2).abs();
            if (area < best) best = area;
          }
        }
      }
    }
    return best == (1 << 62) ? 0 : best;
  }
}
