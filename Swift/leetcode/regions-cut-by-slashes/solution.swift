class Solution {
    func regionsBySlashes(_ grid: [String]) -> Int {
        let n = grid.count
        var parent = Array(0..<(4 * n * n))
        func find(_ x: Int) -> Int {
            var x = x
            while parent[x] != x {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }
        func union(_ a: Int, _ b: Int) {
            let ra = find(a), rb = find(b)
            if ra != rb { parent[ra] = rb }
        }
        for r in 0..<n {
            let row = Array(grid[r])
            for c in 0..<n {
                let base = 4 * (r * n + c)
                let top = base, right = base + 1, bottom = base + 2, left = base + 3
                let ch: Character = c < row.count ? row[c] : " "
                if ch == "/" {
                    union(top, left)
                    union(right, bottom)
                } else if ch == "\\" {
                    union(top, right)
                    union(left, bottom)
                } else {
                    union(top, right)
                    union(right, bottom)
                    union(bottom, left)
                }
                if c + 1 < n { union(right, 4 * (r * n + c + 1) + 3) }
                if r + 1 < n { union(bottom, 4 * ((r + 1) * n + c)) }
            }
        }
        var cnt = 0
        for i in 0..<(4 * n * n) {
            if find(i) == i { cnt += 1 }
        }
        return cnt
    }
}
