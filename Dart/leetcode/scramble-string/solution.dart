class Solution {
  bool isScramble(String s1, String s2) {
    if (s1.length != s2.length) {
      return false;
    }
    final n = s1.length;
    if (n == 0) {
      return true;
    }
    final dp = List.generate(
        n + 1, (_) => List.generate(n, (_) => List<bool>.filled(n, false)));

    bool checkEqual(int i1, int i2, int length) {
      final a = s1.substring(i1, i1 + length).split('')..sort();
      final b = s2.substring(i2, i2 + length).split('')..sort();
      for (var t = 0; t < a.length; t++) {
        if (a[t] != b[t]) return false;
      }
      return true;
    }

    for (var length = 1; length <= n; length++) {
      for (var i = 0; i <= n - length; i++) {
        for (var j = 0; j <= n - length; j++) {
          if (checkEqual(i, j, length) && length == 1) {
            dp[length][i][j] = true;
          } else if (checkEqual(i, j, length)) {
            for (var k = 1; k < length; k++) {
              if ((dp[k][i][j] && dp[length - k][i + k][j + k]) ||
                  (dp[k][i][j + length - k] && dp[length - k][i + k][j])) {
                dp[length][i][j] = true;
                break;
              }
            }
          }
        }
      }
    }
    return dp[n][0][0];
  }
}
