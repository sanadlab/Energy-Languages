class Solution {
    func shuffle(_ nums: [Int], _ n: Int) -> [Int] {
        let m = nums.count / 2
        var res: [Int] = []
        for i in 0..<m {
            res.append(nums[i])
            res.append(nums[i + m])
        }
        return res
    }
}
