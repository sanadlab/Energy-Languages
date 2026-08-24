class Solution {
    func shiftGrid(_ grid: [[Int]], _ k: Int) -> [[Int]] {
        let m = grid.count, n = grid[0].count, total = m*n, kk = k % total
        var res = Array(repeating: Array(repeating: 0, count: n), count: m)
        for i in 0..<total { let ni = (i + kk) % total; res[ni/n][ni%n] = grid[i/n][i%n] }
        return res
    }
}
