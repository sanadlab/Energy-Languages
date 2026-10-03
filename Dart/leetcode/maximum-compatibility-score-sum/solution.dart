class Solution {
  int maxCompatibilitySum(List<List<int>> students, List<List<int>> mentors) {
    int m = students.length;
    int n = m > 0 ? students[0].length : 0;
    List<List<int>> score = List.generate(m, (_) => List<int>.filled(m, 0));
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < m; j++) {
        int s = 0;
        for (int k = 0; k < n; k++) {
          if (students[i][k] == mentors[j][k]) s++;
        }
        score[i][j] = s;
      }
    }
    List<int> dp = List<int>.filled(1 << m, 0);
    for (int mask = 0; mask < (1 << m); mask++) {
      int i = _popcount(mask);
      if (i >= m) continue;
      for (int j = 0; j < m; j++) {
        if (((mask >> j) & 1) == 1) continue;
        int nm = mask | (1 << j);
        int val = dp[mask] + score[i][j];
        if (val > dp[nm]) dp[nm] = val;
      }
    }
    return dp[(1 << m) - 1];
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
