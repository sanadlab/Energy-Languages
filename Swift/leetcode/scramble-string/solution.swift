class Solution {
    func isScramble(_ s1: String, _ s2: String) -> Bool {
        if s1.count != s2.count { return false }
        let a1 = Array(s1)
        let a2 = Array(s2)
        let n = a1.count
        if n == 0 { return true }
        var dp = [[[Bool]]](repeating: [[Bool]](repeating: [Bool](repeating: false, count: n), count: n), count: n + 1)
        func checkEqual(_ i1: Int, _ i2: Int, _ length: Int) -> Bool {
            return a1[i1..<(i1 + length)].sorted() == a2[i2..<(i2 + length)].sorted()
        }
        for length in 1...n {
            for i in 0...(n - length) {
                for j in 0...(n - length) {
                    if checkEqual(i, j, length) && length == 1 {
                        dp[length][i][j] = true
                    } else if checkEqual(i, j, length) {
                        for k in 1..<length {
                            if (dp[k][i][j] && dp[length - k][i + k][j + k]) ||
                               (dp[k][i][j + length - k] && dp[length - k][i + k][j]) {
                                dp[length][i][j] = true
                                break
                            }
                        }
                    }
                }
            }
        }
        return dp[n][0][0]
    }
}
