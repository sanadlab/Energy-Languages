class Solution {
public:
    bool isScramble(string s1, string s2) {
        int n = s1.size();
        if (s1 == s2) return true;
        // If sorted characters differ, no need to check further
        string t1 = s1, t2 = s2;
        sort(t1.begin(), t1.end());
        sort(t2.begin(), t2.end());
        if (t1 != t2) return false;

        // dp[i][j][len] = whether s1.substr(i,len) is scramble of s2.substr(j,len)
        vector<vector<vector<int>>> dp(n, vector<vector<int>>(n, vector<int>(n+1, -1)));

        function<bool(int,int,int)> dfs = [&](int i, int j, int len) -> bool {
            if (dp[i][j][len] != -1) return dp[i][j][len];
            string a = s1.substr(i,len);
            string b = s2.substr(j,len);
            if (a == b) return dp[i][j][len] = true;

            // Check character counts to prune
            int count[26] = {0};
            for (int k = 0; k < len; ++k) {
                count[a[k]-'a']++;
                count[b[k]-'a']--;
            }
            for (int c = 0; c < 26; ++c) {
                if (count[c] != 0) return dp[i][j][len] = false;
            }

            for (int split = 1; split < len; ++split) {
                // Case 1: no swap
                if (dfs(i, j, split) && dfs(i+split, j+split, len-split)) {
                    return dp[i][j][len] = true;
                }
                // Case 2: swap
                if (dfs(i, j+len-split, split) && dfs(i+split, j, len-split)) {
                    return dp[i][j][len] = true;
                }
            }
            return dp[i][j][len] = false;
        };

        return dfs(0, 0, n);
    }
};