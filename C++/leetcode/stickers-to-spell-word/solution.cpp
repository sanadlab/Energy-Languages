class Solution {
public:
    int minStickers(vector<string>& stickers, string target) {
        int n = target.size();
        int full = (1 << n) - 1;
        vector<int> dp(1 << n, INT_MAX);
        dp[0] = 0;
        int m = stickers.size();
        vector<vector<int>> cnt(m, vector<int>(26, 0));
        for (int j = 0; j < m; j++)
            for (char c : stickers[j]) cnt[j][c - 'a']++;
        for (int state = 0; state <= full; state++) {
            if (dp[state] == INT_MAX) continue;
            for (int j = 0; j < m; j++) {
                vector<int> avail = cnt[j];
                int nxt = state;
                for (int i = 0; i < n; i++) {
                    if (!(state & (1 << i))) {
                        int c = target[i] - 'a';
                        if (avail[c] > 0) { avail[c]--; nxt |= (1 << i); }
                    }
                }
                if (dp[state] + 1 < dp[nxt]) dp[nxt] = dp[state] + 1;
            }
        }
        return dp[full] == INT_MAX ? -1 : dp[full];
    }
};
