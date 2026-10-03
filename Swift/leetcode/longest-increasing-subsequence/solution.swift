class Solution {
    func lengthOfLIS(_ nums: [Int]) -> Int {
        var tails = [Int]()
        for x in nums {
            var lo = 0
            var hi = tails.count
            while lo < hi {
                let mid = (lo + hi) / 2
                if tails[mid] < x {
                    lo = mid + 1
                } else {
                    hi = mid
                }
            }
            if lo == tails.count {
                tails.append(x)
            } else {
                tails[lo] = x
            }
        }
        return tails.count
    }
}
