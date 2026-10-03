class Solution {
  int minCost(int maxTime, List<List<int>> edges, List<int> passingFees) {
    int n = passingFees.length;
    int inf = 1 << 29;
    List<List<List<int>>> adj = List.generate(n, (_) => <List<int>>[]);
    for (List<int> e in edges) {
      if (e.length < 3) continue;
      int x = e[0], y = e[1], w = e[2];
      if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue;
      adj[x].add([y, w]);
      adj[y].add([x, w]);
    }
    List<List<int>> dp =
        List.generate(maxTime + 1, (_) => List<int>.filled(n, inf));
    dp[0][0] = passingFees[0];
    int ans = inf;
    for (int t = 0; t <= maxTime; t++) {
      List<int> row = dp[t];
      for (int u = 0; u < n; u++) {
        int cur = row[u];
        if (cur >= inf) continue;
        if (u == n - 1 && cur < ans) ans = cur;
        for (List<int> edge in adj[u]) {
          int v = edge[0], w = edge[1];
          int nt = t + w;
          if (nt <= maxTime && cur + passingFees[v] < dp[nt][v]) {
            dp[nt][v] = cur + passingFees[v];
          }
        }
      }
    }
    return ans >= inf ? -1 : ans;
  }
}
