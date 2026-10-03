class Solution {
  bool isMatch(String s, String p) {
    final m = s.length, n = p.length;
    final dp = List.generate(m + 1, (_) => List<bool>.filled(n + 1, false));
    dp[m][n] = true;
    for (var i = m; i >= 0; i--) {
      for (var j = n - 1; j >= 0; j--) {
        final first = i < m && (p[j] == s[i] || p[j] == '.');
        if (j + 1 < n && p[j + 1] == '*') {
          dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j]);
        } else {
          dp[i][j] = first && dp[i + 1][j + 1];
        }
      }
    }
    return dp[0][0];
  }
}
