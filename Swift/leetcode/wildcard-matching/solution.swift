class Solution {
    func isMatch(_ s: String, _ p: String) -> Bool {
        let sc = Array(s)
        let pc = Array(p)
        let m = sc.count, n = pc.count
        var dp = [[Bool]](repeating: [Bool](repeating: false, count: n + 1), count: m + 1)
        dp[0][0] = true
        var j = 1
        while j <= n {
            if pc[j - 1] == "*" {
                dp[0][j] = dp[0][j - 1]
            }
            j += 1
        }
        var i = 1
        while i <= m {
            var jj = 1
            while jj <= n {
                let pch = pc[jj - 1]
                if pch == sc[i - 1] || pch == "?" {
                    dp[i][jj] = dp[i - 1][jj - 1]
                } else if pch == "*" {
                    dp[i][jj] = dp[i - 1][jj] || dp[i][jj - 1]
                }
                jj += 1
            }
            i += 1
        }
        return dp[m][n]
    }
}
