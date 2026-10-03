
class Solution {

    private let nums: [Int]

    init(_ nums: [Int]) {
        self.nums = nums
    }

    func pick(_ target: Int) -> Int {
        // Reservoir sampling: pick a uniformly random index among all
        // positions whose value equals target, using O(1) extra space.
        var count = 0
        var res = -1
        for i in 0..<nums.count {
            if nums[i] == target {
                count += 1
                if Int.random(in: 1...count) == 1 {
                    res = i
                }
            }
        }
        return res
    }
}

/**
 * Your Solution object will be instantiated and called as such:
 * let obj = Solution(nums)
 * let ret_1: Int = obj.pick(target)
 */
