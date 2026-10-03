class Solution {
    func maxScore(_ nums: [Int]) -> Int {
        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a, b = b
            while b != 0 { (a, b) = (b, a % b) }
            return a
        }
        let m = nums.count
        var dp = [Int](repeating: 0, count: 1 << m)
        var best = 0
        for mask in 0..<(1 << m) {
            let cnt = mask.nonzeroBitCount
            if cnt & 1 == 1 { continue }
            let op = cnt / 2 + 1
            for i in 0..<m {
                if (mask >> i) & 1 == 1 { continue }
                var j = i + 1
                while j < m {
                    if (mask >> j) & 1 == 1 { j += 1; continue }
                    let nm = mask | (1 << i) | (1 << j)
                    let val = dp[mask] + op * gcd(nums[i], nums[j])
                    if val > dp[nm] {
                        dp[nm] = val
                        if val > best { best = val }
                    }
                    j += 1
                }
            }
        }
        return best
    }
}
