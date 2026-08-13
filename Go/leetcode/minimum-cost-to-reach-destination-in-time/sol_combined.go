package main

func minCost(maxTime int, edges [][]int, passingFees []int) int {
    n := len(passingFees)
    const INF = 1 << 29
    type edge struct{ v, w int }
    adj := make([][]edge, n)
    for _, e := range edges {
        if len(e) < 3 {
            continue
        }
        x, y, w := e[0], e[1], e[2]
        if x < 0 || x >= n || y < 0 || y >= n || w < 0 {
            continue
        }
        adj[x] = append(adj[x], edge{y, w})
        adj[y] = append(adj[y], edge{x, w})
    }
    dp := make([][]int, maxTime+1)
    for t := 0; t <= maxTime; t++ {
        dp[t] = make([]int, n)
        for u := 0; u < n; u++ {
            dp[t][u] = INF
        }
    }
    dp[0][0] = passingFees[0]
    ans := INF
    for t := 0; t <= maxTime; t++ {
        for u := 0; u < n; u++ {
            cur := dp[t][u]
            if cur >= INF {
                continue
            }
            if u == n-1 && cur < ans {
                ans = cur
            }
            for _, e := range adj[u] {
                nt := t + e.w
                if nt <= maxTime && cur+passingFees[e.v] < dp[nt][e.v] {
                    dp[nt][e.v] = cur + passingFees[e.v]
                }
            }
        }
    }
    if ans >= INF {
        return -1
    }
    return ans
}
