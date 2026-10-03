class Solution {
    func minCost(_ maxTime: Int, _ edges: [[Int]], _ passingFees: [Int]) -> Int {
        let n = passingFees.count
        let INF = 1 << 29
        var adj = Array(repeating: [(Int, Int)](), count: n)
        for e in edges {
            if e.count < 3 { continue }
            let x = e[0], y = e[1], w = e[2]
            if x < 0 || x >= n || y < 0 || y >= n || w < 0 { continue }
            adj[x].append((y, w))
            adj[y].append((x, w))
        }
        var dp = Array(repeating: Array(repeating: INF, count: n), count: maxTime + 1)
        dp[0][0] = passingFees[0]
        var ans = INF
        for t in 0...maxTime {
            for u in 0..<n {
                let cur = dp[t][u]
                if cur >= INF { continue }
                if u == n - 1 && cur < ans { ans = cur }
                for (v, w) in adj[u] {
                    let nt = t + w
                    if nt <= maxTime && cur + passingFees[v] < dp[nt][v] {
                        dp[nt][v] = cur + passingFees[v]
                    }
                }
            }
        }
        return ans >= INF ? -1 : ans
    }
}
