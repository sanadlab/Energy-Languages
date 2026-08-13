public class Solution {
    public int MaxCompatibilitySum(int[][] students, int[][] mentors) {
        int m = students.Length;
        int n = m > 0 ? students[0].Length : 0;
        int[,] score = new int[m, m];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < m; j++)
                for (int k = 0; k < n; k++)
                    if (students[i][k] == mentors[j][k]) score[i, j]++;
        int[] dp = new int[1 << m];
        for (int mask = 0; mask < (1 << m); mask++) {
            int cnt = 0; for (int x = mask; x > 0; x >>= 1) cnt += x & 1;
            if (cnt >= m) continue;
            for (int j = 0; j < m; j++) {
                if (((mask >> j) & 1) == 1) continue;
                int nm = mask | (1 << j);
                int val = dp[mask] + score[cnt, j];
                if (val > dp[nm]) dp[nm] = val;
            }
        }
        return dp[(1 << m) - 1];
    }
}
