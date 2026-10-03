class Solution {
    func maxRunTime(_ n: Int, _ batteries: [Int]) -> Int {
        let total = batteries.reduce(0, +)
        var lo = 0, hi = total / n
        while lo < hi {
            let mid = (lo + hi + 1) / 2
            var avail = 0
            for b in batteries { avail += min(b, mid) }
            if avail >= n * mid {
                lo = mid
            } else {
                hi = mid - 1
            }
        }
        return lo
    }
}
