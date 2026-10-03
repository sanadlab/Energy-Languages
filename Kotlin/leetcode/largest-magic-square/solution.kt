class Solution {
    fun largestMagicSquare(grid: Array<IntArray>): Int {
        val m = grid.size
        val n = grid[0].size

        fun isMagicSquare(r: Int, c: Int, k: Int): Boolean {
            var total = 0
            for (j in c until c + k) total += grid[r + k - 1][j]
            for (i in 0 until k) {
                var rowSum = 0
                var colSum = 0
                for (j in 0 until k) {
                    rowSum += grid[r + i][c + j]
                    colSum += grid[r + j][c + i]
                }
                if (rowSum != total || colSum != total) return false
            }
            var diag1 = 0
            var diag2 = 0
            for (i in 0 until k) {
                diag1 += grid[r + i][c + i]
                diag2 += grid[r + k - 1 - i][c + i]
            }
            return diag1 == total && diag2 == total
        }

        for (k in minOf(m, n) downTo 2) {
            for (i in 0..m - k) {
                for (j in 0..n - k) {
                    if (isMagicSquare(i, j, k)) return k
                }
            }
        }

        return 1
    }
}
