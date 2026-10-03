class Solution {
    func kLengthApart(_ nums: [Int], _ k: Int) -> Bool {
        var prev = -1
        for (i, v) in nums.enumerated() {
            if v == 1 {
                if prev != -1 && i - prev - 1 < k {
                    return false
                }
                prev = i
            }
        }
        return true
    }
}
