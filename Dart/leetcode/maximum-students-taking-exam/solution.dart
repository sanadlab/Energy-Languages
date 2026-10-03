class Solution {
  int maxStudents(List<List<String>> seats) {
    int m = seats.length;
    if (m == 0) return 0;
    int n = seats[0].length;
    List<int> avail = List<int>.filled(m, 0);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (j < seats[i].length && seats[i][j] == '.') {
          avail[i] |= (1 << j);
        }
      }
    }
    int full = 1 << n;
    List<int> best = List<int>.filled(full, -1);
    best[0] = 0;
    for (int i = 0; i < m; i++) {
      List<int> ndp = List<int>.filled(full, -1);
      for (int mask = 0; mask < full; mask++) {
        if ((mask & avail[i]) != mask) continue;
        if ((mask & (mask << 1)) != 0) continue;
        int pc = _popcount(mask);
        for (int pmask = 0; pmask < full; pmask++) {
          if (best[pmask] < 0) continue;
          if ((mask & (pmask << 1)) != 0) continue;
          if ((mask & (pmask >> 1)) != 0) continue;
          int val = best[pmask] + pc;
          if (val > ndp[mask]) ndp[mask] = val;
        }
      }
      best = ndp;
    }
    int res = best[0];
    for (int x in best) {
      if (x > res) res = x;
    }
    return res;
  }

  int _popcount(int x) {
    int c = 0;
    while (x != 0) {
      c += x & 1;
      x >>= 1;
    }
    return c;
  }
}
