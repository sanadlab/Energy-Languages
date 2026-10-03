class Solution {
  int maxRunTime(int n, List<int> batteries) {
    int total = 0;
    for (int b in batteries) total += b;
    int lo = 0, hi = total ~/ n;
    while (lo < hi) {
      int mid = (lo + hi + 1) ~/ 2;
      int avail = 0;
      for (int b in batteries) avail += (b < mid ? b : mid);
      if (avail >= n * mid) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo;
  }
}
