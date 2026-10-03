class Solution {
    func isMatch(_ s: String, _ p: String) -> Bool {
        let sc = Array(s)
        let pc = Array(p)
        let m = sc.count
        let n = pc.count
        var dp = [[Bool]](repeating: [Bool](repeating: false, count: n + 1), count: m + 1)
        dp[m][n] = true
        for i in stride(from: m, through: 0, by: -1) {
            for j in stride(from: n - 1, through: 0, by: -1) {
                let first = i < m && (pc[j] == sc[i] || pc[j] == ".")
                if j + 1 < n && pc[j + 1] == "*" {
                    dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j])
                } else {
                    dp[i][j] = first && dp[i + 1][j + 1]
                }
            }
        }
        return dp[0][0]
    }
}
