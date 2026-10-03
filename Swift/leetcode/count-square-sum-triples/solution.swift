class Solution {
    func countTriples(_ n: Int) -> Int {
        var count = 0
        for a in 1...n {
            for b in a...n {
                let cSquare = a * a + b * b
                var c = Int(Double(cSquare).squareRoot())
                while (c + 1) * (c + 1) <= cSquare { c += 1 }
                while c * c > cSquare { c -= 1 }
                if c <= n && c * c == cSquare {
                    count += 2
                }
            }
        }
        return count
    }
}
