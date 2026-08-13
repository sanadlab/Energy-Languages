class Solution {
public:
    int maxCompatibilitySum(vector<vector<int>>& students, vector<vector<int>>& mentors) {
        int m = students.size();
        int n = m ? students[0].size() : 0;
        vector<vector<int>> score(m, vector<int>(m, 0));
        for (int i = 0; i < m; ++i)
            for (int j = 0; j < m; ++j)
                for (int k = 0; k < n; ++k)
                    if (students[i][k] == mentors[j][k]) score[i][j]++;
        vector<int> dp(1 << m, 0);
        for (int mask = 0; mask < (1 << m); ++mask) {
            int i = __builtin_popcount(mask);
            if (i >= m) continue;
            for (int j = 0; j < m; ++j) {
                if ((mask >> j) & 1) continue;
                int nm = mask | (1 << j);
                int val = dp[mask] + score[i][j];
                if (val > dp[nm]) dp[nm] = val;
            }
        }
        return dp[(1 << m) - 1];
    }
};
