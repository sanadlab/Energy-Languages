class Solution {
  int minDays(List<int> bloomDay, int m, int k) {
    if (m * k > bloomDay.length) return -1;
    bool canMake(int day) {
      int bouquets = 0, flowers = 0;
      for (int b in bloomDay) {
        if (b <= day) {
          flowers++;
          if (flowers == k) {
            bouquets++;
            flowers = 0;
          }
        } else {
          flowers = 0;
        }
      }
      return bouquets >= m;
    }

    int lo = bloomDay.reduce((a, b) => a < b ? a : b);
    int hi = bloomDay.reduce((a, b) => a > b ? a : b);
    while (lo < hi) {
      int mid = (lo + hi) ~/ 2;
      if (canMake(mid)) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }
    return lo;
  }
}
