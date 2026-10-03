class Solution {
    func canPartitionKSubsets(_ nums: [Int], _ k: Int) -> Bool {
        if k <= 0 || nums.count < k {
            return false
        }
        let total = nums.reduce(0, +)
        if total % k != 0 {
            return false
        }
        let target = total / k
        let sorted = nums.sorted(by: >)
        if sorted[0] > target {
            return false
        }
        let n = sorted.count
        var used = [Bool](repeating: false, count: n)
        func backtrack(_ k: Int, _ cur: Int, _ start: Int) -> Bool {
            if k == 0 {
                return true
            }
            if cur == target {
                return backtrack(k - 1, 0, 0)
            }
            for i in start..<n {
                if used[i] || cur + sorted[i] > target {
                    continue
                }
                used[i] = true
                if backtrack(k, cur + sorted[i], i + 1) {
                    return true
                }
                used[i] = false
                if cur == 0 {
                    break
                }
            }
            return false
        }
        return backtrack(k, 0, 0)
    }
}
