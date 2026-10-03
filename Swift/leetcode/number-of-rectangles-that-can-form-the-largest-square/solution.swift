class Solution {
    func countGoodRectangles(_ rectangles: [[Int]]) -> Int {
        var maxLen = 0
        var count = 0
        for r in rectangles {
            let side = min(r[0], r[1])
            if side > maxLen {
                maxLen = side
                count = 1
            } else if side == maxLen {
                count += 1
            }
        }
        return count
    }
}
