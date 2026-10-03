class Solution {
  int maxPoints(List<List<int>> points) {
    final int n = points.length;
    if (n <= 2) {
      return n;
    }
    int best = 1;
    for (int i = 0; i < n; i++) {
      final Map<String, int> slopes = {};
      for (int j = i + 1; j < n; j++) {
        int dx = points[j][0] - points[i][0];
        int dy = points[j][1] - points[i][1];
        final int g = dx.abs().gcd(dy.abs());
        dx ~/= g;
        dy ~/= g;
        if (dx < 0 || (dx == 0 && dy < 0)) {
          dx = -dx;
          dy = -dy;
        }
        final String key = "$dx,$dy";
        final int c = (slopes[key] ?? 0) + 1;
        slopes[key] = c;
        if (c + 1 > best) {
          best = c + 1;
        }
      }
    }
    return best;
  }
}
