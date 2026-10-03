class Solution {
    func maxSizeSlices(_ slices: [Int]) -> Int {
        func best(_ nums: [Int], _ k: Int) -> Int {
            let n = nums.count
            let NEG = Int.min / 2
            var dp = [[Int]](repeating: [Int](repeating: NEG, count: k + 1), count: n + 1)
            for i in 0...n { dp[i][0] = 0 }
            for i in 1...n {
                for j in 1...k {
                    let skip = dp[i - 1][j]
                    let prev: Int
                    if i >= 2 {
                        prev = dp[i - 2][j - 1]
                    } else {
                        prev = (j == 1) ? 0 : NEG
                    }
                    let take = prev + nums[i - 1]
                    dp[i][j] = max(skip, take)
                }
            }
            return dp[n][k]
        }
        let total = slices.count
        let k = total / 3
        if k == 0 { return 0 }
        return max(best(Array(slices[0..<(total - 1)]), k), best(Array(slices[1..<total]), k))
    }
}
