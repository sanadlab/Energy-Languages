class Solution {
    func countMaxOrSubsets(_ nums: [Int]) -> Int {
        var maxOr = 0
        for num in nums {
            maxOr |= num
        }
        let n = nums.count
        var count = 0
        for mask in 1..<(1 << n) {
            var cur = 0
            for i in 0..<n {
                if mask & (1 << i) != 0 {
                    cur |= nums[i]
                }
            }
            if cur == maxOr {
                count += 1
            }
        }
        return count
    }
}
