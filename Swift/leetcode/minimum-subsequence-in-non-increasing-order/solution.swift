class Solution {
    func minSubsequence(_ nums: [Int]) -> [Int] {
        let ordered = nums.sorted(by: >)
        let total = ordered.reduce(0, +)
        var running = 0
        var res = [Int]()
        for x in ordered {
            running += x
            res.append(x)
            if running * 2 > total { break }
        }
        return res
    }
}
