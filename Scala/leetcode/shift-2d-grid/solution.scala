object Solution {
    def shiftGrid(grid: Array[Array[Int]], k: Int): Array[Array[Int]] = {
        val m = grid.length; val n = grid(0).length; val total = m * n; val kk = k % total
        val res = Array.ofDim[Int](m, n)
        for (i <- 0 until total) { val ni = (i + kk) % total; res(ni / n)(ni % n) = grid(i / n)(i % n) }
        res
    }
}
