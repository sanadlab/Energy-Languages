class Solution {
    func maximumANDSum(_ nums: [Int], _ numSlots: Int) -> Int {
        let n = nums.count
        let full = (1 << n) - 1
        var dp = [Int](repeating: -1, count: 1 << n)
        dp[0] = 0
        for slot in 1...numSlots {
            var ndp = dp
            for mask in 0..<(1 << n) {
                if dp[mask] < 0 { continue }
                let base = dp[mask]
                for i in 0..<n {
                    if (mask >> i) & 1 == 1 { continue }
                    let nm = mask | (1 << i)
                    let v = base + (nums[i] & slot)
                    if v > ndp[nm] { ndp[nm] = v }
                    var j = i + 1
                    while j < n {
                        if (mask >> j) & 1 == 0 {
                            let nm2 = nm | (1 << j)
                            let v2 = v + (nums[j] & slot)
                            if v2 > ndp[nm2] { ndp[nm2] = v2 }
                        }
                        j += 1
                    }
                }
            }
            dp = ndp
        }
        return dp[full] >= 0 ? dp[full] : 0
    }
}
