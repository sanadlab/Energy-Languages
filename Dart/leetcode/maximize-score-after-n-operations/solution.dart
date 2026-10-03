class Solution {
  int maxScore(List<int> nums) {
    int m = nums.length;
    List<int> dp = List<int>.filled(1 << m, 0);
    int best = 0;
    for (int mask = 0; mask < (1 << m); mask++) {
      int cnt = _popcount(mask);
      if ((cnt & 1) == 1) continue;
      int op = cnt ~/ 2 + 1;
      for (int i = 0; i < m; i++) {
        if (((mask >> i) & 1) == 1) continue;
        for (int j = i + 1; j < m; j++) {
          if (((mask >> j) & 1) == 1) continue;
          int nm = mask | (1 << i) | (1 << j);
          int val = dp[mask] + op * _gcd(nums[i], nums[j]);
          if (val > dp[nm]) {
            dp[nm] = val;
            if (val > best) best = val;
          }
        }
      }
    }
    return best;
  }

  int _popcount(int x) {
    int c = 0;
    while (x != 0) {
      c += x & 1;
      x >>= 1;
    }
    return c;
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int t = a % b;
      a = b;
      b = t;
    }
    return a;
  }
}
