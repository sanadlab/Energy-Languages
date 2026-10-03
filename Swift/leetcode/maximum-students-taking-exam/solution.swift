class Solution {
    func maxStudents(_ seats: [[Character]]) -> Int {
        let m = seats.count
        if m == 0 { return 0 }
        let n = seats[0].count
        var avail = [Int](repeating: 0, count: m)
        for i in 0..<m {
            for j in 0..<n {
                if j < seats[i].count && seats[i][j] == "." {
                    avail[i] |= (1 << j)
                }
            }
        }
        let full = 1 << n
        var best = [Int](repeating: -1, count: full)
        best[0] = 0
        for i in 0..<m {
            var ndp = [Int](repeating: -1, count: full)
            for mask in 0..<full {
                if (mask & avail[i]) != mask { continue }
                if mask & (mask << 1) != 0 { continue }
                let pc = mask.nonzeroBitCount
                for pmask in 0..<full {
                    if best[pmask] < 0 { continue }
                    if mask & (pmask << 1) != 0 { continue }
                    if mask & (pmask >> 1) != 0 { continue }
                    let val = best[pmask] + pc
                    if val > ndp[mask] { ndp[mask] = val }
                }
            }
            best = ndp
        }
        return best.max()!
    }
}
