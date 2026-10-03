class Solution {
    fun shiftGrid(grid: Array<IntArray>, k: Int): List<List<Int>> {
        val m = grid.size
        if (m == 0) return grid.map { it.toList() }
        val n = grid[0].size
        if (n == 0) return grid.map { it.toList() }
        val total = m * n
        val kk = k % total
        val flat = IntArray(total)
        var t = 0
        for (i in 0 until m) {
            for (j in 0 until n) {
                flat[t++] = grid[i][j]
            }
        }
        val res = Array(m) { IntArray(n) }
        for (idx in 0 until total) {
            val np = (idx + kk) % total
            res[np / n][np % n] = flat[idx]
        }
        return res.map { it.toList() }
    }
}
