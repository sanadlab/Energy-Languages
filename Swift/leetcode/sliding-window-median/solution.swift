class Solution {
    func medianSlidingWindow(_ nums: [Int], _ k: Int) -> [Double] {
        var res = [Double]()
        let n = nums.count
        var i = 0
        while i <= n - k {
            let w = nums[i..<(i + k)].sorted()
            let median: Double
            if k % 2 == 1 {
                median = Double(w[k / 2])
            } else {
                median = (Double(w[k / 2 - 1]) + Double(w[k / 2])) / 2.0
            }
            res.append(median)
            i += 1
        }
        return res
    }
}
