class Solution {
    func maxSumTwoNoOverlap(_ nums: [Int], _ firstLen: Int, _ secondLen: Int) -> Int {
        let n = nums.count
        var pre = [Int](repeating: 0, count: n + 1)
        for i in 0..<n {
            pre[i + 1] = pre[i] + nums[i]
        }
        func best(_ L: Int, _ M: Int) -> Int {
            var res = 0
            var maxL = 0
            var i = L + M
            while i <= n {
                maxL = max(maxL, pre[i - M] - pre[i - M - L])
                res = max(res, maxL + pre[i] - pre[i - M])
                i += 1
            }
            return res
        }
        return max(best(firstLen, secondLen), best(secondLen, firstLen))
    }
}
