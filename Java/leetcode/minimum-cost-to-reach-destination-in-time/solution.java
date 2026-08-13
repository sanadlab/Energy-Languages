class Solution {
    public int minCost(int maxTime, int[][] edges, int[] passingFees) {
        int n = passingFees.length;
        final int INF = 1 << 29;
        java.util.List<int[]>[] adj = new java.util.List[n];
        for (int i = 0; i < n; i++) adj[i] = new java.util.ArrayList<>();
        for (int[] e : edges) {
            if (e.length < 3) continue;
            int x = e[0], y = e[1], w = e[2];
            if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue;
            adj[x].add(new int[]{y, w});
            adj[y].add(new int[]{x, w});
        }
        int[][] dp = new int[maxTime + 1][n];
        for (int[] row : dp) java.util.Arrays.fill(row, INF);
        dp[0][0] = passingFees[0];
        int ans = INF;
        for (int t = 0; t <= maxTime; t++) {
            for (int u = 0; u < n; u++) {
                int cur = dp[t][u];
                if (cur >= INF) continue;
                if (u == n - 1) ans = Math.min(ans, cur);
                for (int[] e : adj[u]) {
                    int nt = t + e[1];
                    if (nt <= maxTime && cur + passingFees[e[0]] < dp[nt][e[0]])
                        dp[nt][e[0]] = cur + passingFees[e[0]];
                }
            }
        }
        return ans >= INF ? -1 : ans;
    }
}
