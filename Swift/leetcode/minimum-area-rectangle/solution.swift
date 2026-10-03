class Solution {
    func minAreaRect(_ points: [[Int]]) -> Int {
        var seen = Set<Int>()
        let n = points.count
        for p in points {
            seen.insert(p[0] * 50000 + p[1])
        }
        var best = Int.max
        for i in 0..<n {
            let x1 = points[i][0], y1 = points[i][1]
            for j in (i + 1)..<n {
                let x2 = points[j][0], y2 = points[j][1]
                if x1 != x2 && y1 != y2 {
                    if seen.contains(x1 * 50000 + y2) && seen.contains(x2 * 50000 + y1) {
                        let area = abs(x1 - x2) * abs(y1 - y2)
                        if area < best { best = area }
                    }
                }
            }
        }
        return best == Int.max ? 0 : best
    }
}
