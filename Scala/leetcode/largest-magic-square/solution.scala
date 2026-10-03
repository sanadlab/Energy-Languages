object Solution {
    def largestMagicSquare(grid: Array[Array[Int]]): Int = {
        val m = grid.length
        val n = grid(0).length
        def isMagic(r: Int, c: Int, k: Int): Boolean = {
            var total = 0
            var j = 0
            while (j < k) { total += grid(r + k - 1)(c + j); j += 1 }
            var i = 0
            while (i < k) {
                var rowSum = 0
                var colSum = 0
                var jj = 0
                while (jj < k) {
                    rowSum += grid(r + i)(c + jj)
                    colSum += grid(r + jj)(c + i)
                    jj += 1
                }
                if (rowSum != total || colSum != total) return false
                i += 1
            }
            var diag1 = 0
            var diag2 = 0
            var d = 0
            while (d < k) {
                diag1 += grid(r + d)(c + d)
                diag2 += grid(r + k - 1 - d)(c + d)
                d += 1
            }
            diag1 == total && diag2 == total
        }
        var k = math.min(m, n)
        while (k >= 2) {
            var i = 0
            while (i <= m - k) {
                var j = 0
                while (j <= n - k) {
                    if (isMagic(i, j, k)) return k
                    j += 1
                }
                i += 1
            }
            k -= 1
        }
        1
    }
}
