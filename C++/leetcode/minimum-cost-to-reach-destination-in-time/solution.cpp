class Solution {
public:
    int minCost(int maxTime, vector<vector<int>>& edges, vector<int>& passingFees) {
        int n = passingFees.size();
        const int INF = 1 << 29;
        vector<vector<pair<int,int>>> adj(n);
        for (auto& e : edges) {
            if (e.size() < 3) continue;
            int x = e[0], y = e[1], w = e[2];
            if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue;
            adj[x].push_back({y, w});
            adj[y].push_back({x, w});
        }
        vector<vector<int>> dp(maxTime + 1, vector<int>(n, INF));
        dp[0][0] = passingFees[0];
        int ans = INF;
        for (int t = 0; t <= maxTime; ++t) {
            for (int u = 0; u < n; ++u) {
                int cur = dp[t][u];
                if (cur >= INF) continue;
                if (u == n - 1) ans = min(ans, cur);
                for (auto& pr : adj[u]) {
                    int v = pr.first, w = pr.second;
                    int nt = t + w;
                    if (nt <= maxTime && cur + passingFees[v] < dp[nt][v])
                        dp[nt][v] = cur + passingFees[v];
                }
            }
        }
        return ans >= INF ? -1 : ans;
    }
};
