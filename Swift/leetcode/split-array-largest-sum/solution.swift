class Solution {
    func splitArray(_ nums: [Int], _ k: Int) -> Int {
        var lo = nums.max()!
        var hi = nums.reduce(0, +)
        while lo < hi {
            let mid = (lo + hi) / 2
            var cnt = 1, cur = 0
            for x in nums {
                if cur + x > mid {
                    cnt += 1
                    cur = x
                } else {
                    cur += x
                }
            }
            if cnt <= k {
                hi = mid
            } else {
                lo = mid + 1
            }
        }
        return lo
    }
}
