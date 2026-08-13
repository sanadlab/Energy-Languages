class Solution {
    public int minStickers(String[] stickers, String target) {
        int n = target.length();
        int full = (1 << n) - 1;
        int INF = Integer.MAX_VALUE;
        int[] dp = new int[1 << n];
        java.util.Arrays.fill(dp, INF);
        dp[0] = 0;
        int m = stickers.length;
        int[][] cnt = new int[m][26];
        for (int j = 0; j < m; j++)
            for (char c : stickers[j].toCharArray()) cnt[j][c - 'a']++;
        for (int state = 0; state <= full; state++) {
            if (dp[state] == INF) continue;
            for (int j = 0; j < m; j++) {
                int[] avail = cnt[j].clone();
                int nxt = state;
                for (int i = 0; i < n; i++) {
                    if ((state & (1 << i)) == 0) {
                        int c = target.charAt(i) - 'a';
                        if (avail[c] > 0) { avail[c]--; nxt |= (1 << i); }
                    }
                }
                if (dp[state] + 1 < dp[nxt]) dp[nxt] = dp[state] + 1;
            }
        }
        return dp[full] == INF ? -1 : dp[full];
    }
}
