class Solution {
  int _best(List<int> nums, int k) {
    int n = nums.length;
    const int NEG = -1152921504606846976; // -(1 << 60), stands in for -inf
    List<List<int>> dp =
        List.generate(n + 1, (_) => List<int>.filled(k + 1, NEG));
    for (int i = 0; i <= n; i++) {
      dp[i][0] = 0;
    }
    for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= k; j++) {
        int skip = dp[i - 1][j];
        int prev;
        if (i >= 2) {
          prev = dp[i - 2][j - 1];
        } else {
          prev = (j == 1) ? 0 : NEG;
        }
        int take = prev + nums[i - 1];
        dp[i][j] = skip > take ? skip : take;
      }
    }
    return dp[n][k];
  }

  int maxSizeSlices(List<int> slices) {
    int total = slices.length;
    int k = total ~/ 3;
    if (k == 0) return 0;
    List<int> a = slices.sublist(0, total - 1);
    List<int> b = slices.sublist(1);
    int r1 = _best(a, k);
    int r2 = _best(b, k);
    return r1 > r2 ? r1 : r2;
  }
}
