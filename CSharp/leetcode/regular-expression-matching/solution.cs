public class Solution {
    public bool IsMatch(string s, string p) {
        int m = s.Length, n = p.Length;
        bool[,] dp = new bool[m + 1, n + 1];
        dp[m, n] = true;
        for (int i = m; i >= 0; i--) {
            for (int j = n - 1; j >= 0; j--) {
                bool first = i < m && (p[j] == s[i] || p[j] == '.');
                if (j + 1 < n && p[j + 1] == '*') {
                    dp[i, j] = dp[i, j + 2] || (first && dp[i + 1, j]);
                } else {
                    dp[i, j] = first && dp[i + 1, j + 1];
                }
            }
        }
        return dp[0, 0];
    }
}
