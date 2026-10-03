class Solution {
    func minStartValue(_ nums: [Int]) -> Int {
        var prefix = 0
        var minPrefix = 0
        for x in nums {
            prefix += x
            if prefix < minPrefix {
                minPrefix = prefix
            }
        }
        return max(1, 1 - minPrefix)
    }
}
