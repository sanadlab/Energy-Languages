class Solution {
    func countVowelPermutation(_ n: Int) -> Int {
        let MOD = 1_000_000_007
        var dp = [[Int]](repeating: [Int](repeating: 0, count: 5), count: n + 1)
        for i in 0..<5 {
            dp[1][i] = 1
        }
        if n >= 2 {
            for i in 2...n {
                dp[i][0] = dp[i-1][1] % MOD
                dp[i][1] = (dp[i-1][0] + dp[i-1][2]) % MOD
                dp[i][2] = (dp[i-1][0] + dp[i-1][1] + dp[i-1][3] + dp[i-1][4]) % MOD
                dp[i][3] = (dp[i-1][2] + dp[i-1][4]) % MOD
                dp[i][4] = dp[i-1][0] % MOD
            }
        }
        return dp[n].reduce(0, +) % MOD
    }
}
