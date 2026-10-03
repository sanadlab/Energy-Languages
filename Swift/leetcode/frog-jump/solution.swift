class Solution {
    func canCross(_ stones: [Int]) -> Bool {
        if stones[1] != 1 {
            return false
        }
        let stoneSet = Set(stones)
        var dp: [Int: Set<Int>] = [:]
        for stone in stones {
            dp[stone] = []
        }
        dp[1] = [1]
        for stone in stones {
            if let ks = dp[stone] {
                for k in ks {
                    for step in [k - 1, k, k + 1] {
                        if step > 0 && stoneSet.contains(stone + step) {
                            dp[stone + step, default: []].insert(step)
                        }
                    }
                }
            }
        }
        return !(dp[stones.last!]?.isEmpty ?? true)
    }
}
