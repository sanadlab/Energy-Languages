class Solution {
    func minDays(_ bloomDay: [Int], _ m: Int, _ k: Int) -> Int {
        if m * k > bloomDay.count { return -1 }
        func canMake(_ day: Int) -> Bool {
            var bouquets = 0
            var flowers = 0
            for b in bloomDay {
                if b <= day {
                    flowers += 1
                    if flowers == k {
                        bouquets += 1
                        flowers = 0
                    }
                } else {
                    flowers = 0
                }
            }
            return bouquets >= m
        }
        var lo = bloomDay.min()!
        var hi = bloomDay.max()!
        while lo < hi {
            let mid = (lo + hi) / 2
            if canMake(mid) {
                hi = mid
            } else {
                lo = mid + 1
            }
        }
        return lo
    }
}
