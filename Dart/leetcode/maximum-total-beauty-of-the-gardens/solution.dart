class Solution {
  int maximumBeauty(List<int> flowers, int newFlowers, int target, int full, int partial) {
    int n = flowers.length;
    if (n == 0) return 0;
    List<int> fl =
        List<int>.generate(n, (idx) => flowers[idx] < target ? flowers[idx] : target);
    fl.sort();
    List<int> pre = List<int>.filled(n + 1, 0);
    for (int i = 0; i < n; i++) {
      pre[i + 1] = pre[i] + fl[i];
    }
    if (fl[0] == target) return full * n;
    int ans = 0;
    for (int i = n; i >= 0; i--) {
      int costComplete = target * (n - i) - (pre[n] - pre[i]);
      if (costComplete > newFlowers) continue;
      int rem = newFlowers - costComplete;
      if (i == 0) {
        int cand = full * (n - i);
        if (cand > ans) ans = cand;
        continue;
      }
      int lo = 0, hi = target - 1, bestMin = 0;
      while (lo <= hi) {
        int v = (lo + hi) ~/ 2;
        int k = _bisectLeft(fl, v, i);
        int cost = v * k - pre[k];
        if (cost <= rem) {
          bestMin = v;
          lo = v + 1;
        } else {
          hi = v - 1;
        }
      }
      int cand = full * (n - i) + bestMin * partial;
      if (cand > ans) ans = cand;
    }
    return ans;
  }

  int _bisectLeft(List<int> fl, int v, int hiBound) {
    int lo = 0, hi = hiBound;
    while (lo < hi) {
      int mid = (lo + hi) ~/ 2;
      if (fl[mid] < v) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}
