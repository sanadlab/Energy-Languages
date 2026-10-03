class Solution {
    func largestMagicSquare(_ grid: [[Int]]) -> Int {
        let m = grid.count
        let n = grid[0].count

        func isMagicSquare(_ r: Int, _ c: Int, _ k: Int) -> Bool {
            var total = 0
            for j in 0..<k {
                total += grid[r + k - 1][c + j]
            }
            for i in 0..<k {
                var rowSum = 0, colSum = 0
                for j in 0..<k {
                    rowSum += grid[r + i][c + j]
                    colSum += grid[r + j][c + i]
                }
                if rowSum != total || colSum != total {
                    return false
                }
            }
            var diag1 = 0, diag2 = 0
            for i in 0..<k {
                diag1 += grid[r + i][c + i]
                diag2 += grid[r + k - 1 - i][c + i]
            }
            return diag1 == total && diag2 == total
        }

        var k = min(m, n)
        while k >= 2 {
            for i in 0...(m - k) {
                for j in 0...(n - k) {
                    if isMagicSquare(i, j, k) {
                        return k
                    }
                }
            }
            k -= 1
        }
        return 1
    }
}
