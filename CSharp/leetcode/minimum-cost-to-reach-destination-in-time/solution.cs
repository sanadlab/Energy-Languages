public class Solution {
    public int MinCost(int maxTime, int[][] edges, int[] passingFees) {
        int n = passingFees.Length;
        const int INF = 1 << 29;
        var adj = new List<(int, int)>[n];
        for (int i = 0; i < n; i++) adj[i] = new List<(int, int)>();
        foreach (var e in edges) {
            if (e.Length < 3) continue;
            int x = e[0], y = e[1], w = e[2];
            if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue;
            adj[x].Add((y, w));
            adj[y].Add((x, w));
        }
        int[][] dp = new int[maxTime + 1][];
        for (int t = 0; t <= maxTime; t++) {
            dp[t] = new int[n];
            for (int u = 0; u < n; u++) dp[t][u] = INF;
        }
        dp[0][0] = passingFees[0];
        int ans = INF;
        for (int t = 0; t <= maxTime; t++) {
            for (int u = 0; u < n; u++) {
                int cur = dp[t][u];
                if (cur >= INF) continue;
                if (u == n - 1) ans = Math.Min(ans, cur);
                foreach (var (v, w) in adj[u]) {
                    int nt = t + w;
                    if (nt <= maxTime && cur + passingFees[v] < dp[nt][v])
                        dp[nt][v] = cur + passingFees[v];
                }
            }
        }
        return ans >= INF ? -1 : ans;
    }
}
