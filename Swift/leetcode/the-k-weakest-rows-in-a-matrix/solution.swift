class Solution {
    func kWeakestRows(_ mat: [[Int]], _ k: Int) -> [Int] {
        var counts = [(Int, Int)]()
        for (i, row) in mat.enumerated() {
            counts.append((row.reduce(0, +), i))
        }
        counts.sort { $0.0 != $1.0 ? $0.0 < $1.0 : $0.1 < $1.1 }
        return counts.prefix(k).map { $0.1 }
    }
}
