int minCost(int maxTime, int** edges, int edgesSize, int* edgesColSize, int* passingFees, int passingFeesSize) {
    int n = passingFeesSize;
    const int INF = 1 << 29;

    int* deg = (int*) calloc(n > 0 ? n : 1, sizeof(int));
    for (int e = 0; e < edgesSize; e++) {
        if (edgesColSize[e] < 3) continue;
        int x = edges[e][0], y = edges[e][1], w = edges[e][2];
        if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue;
        deg[x]++; deg[y]++;
    }
    int** adjv = (int**) malloc(sizeof(int*) * (n > 0 ? n : 1));
    int** adjw = (int**) malloc(sizeof(int*) * (n > 0 ? n : 1));
    int* pos = (int*) calloc(n > 0 ? n : 1, sizeof(int));
    for (int i = 0; i < n; i++) {
        adjv[i] = (int*) malloc(sizeof(int) * (deg[i] > 0 ? deg[i] : 1));
        adjw[i] = (int*) malloc(sizeof(int) * (deg[i] > 0 ? deg[i] : 1));
    }
    for (int e = 0; e < edgesSize; e++) {
        if (edgesColSize[e] < 3) continue;
        int x = edges[e][0], y = edges[e][1], w = edges[e][2];
        if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue;
        adjv[x][pos[x]] = y; adjw[x][pos[x]] = w; pos[x]++;
        adjv[y][pos[y]] = x; adjw[y][pos[y]] = w; pos[y]++;
    }

    long cells = (long) (maxTime + 1) * n;
    int* dp = (int*) malloc(sizeof(int) * (cells > 0 ? cells : 1));
    for (long i = 0; i < cells; i++) dp[i] = INF;
    dp[0] = passingFees[0];
    int ans = INF;
    for (int t = 0; t <= maxTime; t++) {
        for (int u = 0; u < n; u++) {
            int cur = dp[(long) t * n + u];
            if (cur >= INF) continue;
            if (u == n - 1 && cur < ans) ans = cur;
            for (int a = 0; a < pos[u]; a++) {
                int v = adjv[u][a], w = adjw[u][a];
                int nt = t + w;
                if (nt <= maxTime && cur + passingFees[v] < dp[(long) nt * n + v])
                    dp[(long) nt * n + v] = cur + passingFees[v];
            }
        }
    }

    for (int i = 0; i < n; i++) { free(adjv[i]); free(adjw[i]); }
    free(adjv); free(adjw); free(deg); free(pos); free(dp);
    return ans >= INF ? -1 : ans;
}
