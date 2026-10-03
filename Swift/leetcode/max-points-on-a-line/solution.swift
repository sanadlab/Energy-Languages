class Solution {
    func maxPoints(_ points: [[Int]]) -> Int {
        let n = points.count
        if n <= 2 {
            return n
        }
        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a, b = b
            while b != 0 {
                let t = a % b
                a = b
                b = t
            }
            return a
        }
        var best = 1
        for i in 0..<n {
            var slopes = [Int: Int]()
            for j in (i + 1)..<n {
                var dx = points[j][0] - points[i][0]
                var dy = points[j][1] - points[i][1]
                let g = gcd(abs(dx), abs(dy))
                if g != 0 {
                    dx /= g
                    dy /= g
                }
                if dx < 0 || (dx == 0 && dy < 0) {
                    dx = -dx
                    dy = -dy
                }
                let key = (dx + 100000) * 1_000_000 + (dy + 100000)
                let c = (slopes[key] ?? 0) + 1
                slopes[key] = c
                if c + 1 > best {
                    best = c + 1
                }
            }
        }
        return best
    }
}
