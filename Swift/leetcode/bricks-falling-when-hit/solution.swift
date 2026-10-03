class Solution {
    func hitBricks(_ grid: [[Int]], _ hits: [[Int]]) -> [Int] {
        let m = grid.count
        let n = m > 0 ? grid[0].count : 0
        let total = m * n
        let top = total
        var parent = Array(0...total)
        var size = Array(repeating: 1, count: total + 1)

        func find(_ x: Int) -> Int {
            var x = x
            while parent[x] != x {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }
        func union(_ a: Int, _ b: Int) {
            var ra = find(a), rb = find(b)
            if ra == rb { return }
            if size[ra] < size[rb] { swap(&ra, &rb) }
            parent[rb] = ra
            size[ra] += size[rb]
        }
        func inBounds(_ r: Int, _ c: Int) -> Bool {
            return 0 <= r && r < m && 0 <= c && c < n
        }

        var g = Array(repeating: Array(repeating: 0, count: n), count: m)
        for r in 0..<m {
            let row = grid[r]
            let cnt = min(n, row.count)
            if cnt > 0 {
                for c in 0..<cnt where row[c] == 1 { g[r][c] = 1 }
            }
        }
        for h in hits {
            if h.count >= 2 && inBounds(h[0], h[1]) { g[h[0]][h[1]] = 0 }
        }
        for r in 0..<m {
            for c in 0..<n where g[r][c] == 1 {
                let cur = r * n + c
                if r == 0 { union(cur, top) }
                if r > 0 && g[r - 1][c] == 1 { union(cur, (r - 1) * n + c) }
                if c > 0 && g[r][c - 1] == 1 { union(cur, r * n + c - 1) }
            }
        }
        let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        var result = Array(repeating: 0, count: hits.count)
        var i = hits.count - 1
        while i >= 0 {
            let h = hits[i]
            if h.count < 2 { i -= 1; continue }
            let r = h[0], c = h[1]
            if !inBounds(r, c) { i -= 1; continue }
            if !(c < grid[r].count && grid[r][c] == 1) { i -= 1; continue }
            let before = size[find(top)]
            g[r][c] = 1
            let cur = r * n + c
            if r == 0 { union(cur, top) }
            for (dr, dc) in dirs {
                let nr = r + dr, nc = c + dc
                if inBounds(nr, nc) && g[nr][nc] == 1 { union(cur, nr * n + nc) }
            }
            let after = size[find(top)]
            result[i] = max(0, after - before - 1)
            i -= 1
        }
        return result
    }
}
