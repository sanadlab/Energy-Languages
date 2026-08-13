public class Solution {
    public int MinStickers(string[] stickers, string target) {
        int n = target.Length;
        int full = (1 << n) - 1;
        int INF = int.MaxValue;
        int[] dp = new int[1 << n];
        for (int i = 0; i < dp.Length; i++) dp[i] = INF;
        dp[0] = 0;
        int m = stickers.Length;
        int[][] cnt = new int[m][];
        for (int j = 0; j < m; j++) {
            cnt[j] = new int[26];
            foreach (char c in stickers[j]) cnt[j][c - 'a']++;
        }
        for (int state = 0; state <= full; state++) {
            if (dp[state] == INF) continue;
            for (int j = 0; j < m; j++) {
                int[] avail = (int[])cnt[j].Clone();
                int nxt = state;
                for (int i = 0; i < n; i++) {
                    if ((state & (1 << i)) == 0) {
                        int c = target[i] - 'a';
                        if (avail[c] > 0) { avail[c]--; nxt |= (1 << i); }
                    }
                }
                if (dp[state] + 1 < dp[nxt]) dp[nxt] = dp[state] + 1;
            }
        }
        return dp[full] == INF ? -1 : dp[full];
    }
}
