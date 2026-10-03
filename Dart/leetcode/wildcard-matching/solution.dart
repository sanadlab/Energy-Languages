class Solution {
  bool isMatch(String s, String p) {
    int m = s.length;
    int n = p.length;
    List<List<bool>> dp =
        List.generate(m + 1, (_) => List<bool>.filled(n + 1, false));
    dp[0][0] = true;

    // Initialize the first row.
    for (int j = 1; j <= n; j++) {
      if (p[j - 1] == '*') dp[0][j] = dp[0][j - 1];
    }

    // Fill the DP table.
    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        String pc = p[j - 1];
        if (pc == s[i - 1] || pc == '?') {
          dp[i][j] = dp[i - 1][j - 1];
        } else if (pc == '*') {
          dp[i][j] = dp[i - 1][j] || dp[i][j - 1];
        }
      }
    }

    return dp[m][n];
  }
}
