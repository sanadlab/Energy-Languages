class Solution {
    func numFactoredBinaryTrees(_ arr: [Int]) -> Int {
        let a = arr.sorted()
        let MOD = 1_000_000_007
        var dp = [Int: Int]()
        for i in 0..<a.count {
            let v = a[i]
            var cnt = 1
            for j in 0..<i {
                let x = a[j]
                if v % x == 0 {
                    let b = v / x
                    if let db = dp[b] {
                        cnt = (cnt + dp[x]! * db) % MOD
                    }
                }
            }
            dp[v] = cnt % MOD
        }
        var total = 0
        for (_, val) in dp {
            total = (total + val) % MOD
        }
        return total
    }
}
