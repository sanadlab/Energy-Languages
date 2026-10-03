object Solution {
    def maxStudents(seats: Array[Array[Char]]): Int = {
        val m = seats.length
        if (m == 0) return 0
        val n = seats(0).length
        val avail = Array.fill(m)(0)
        for (i <- 0 until m) {
            for (j <- 0 until n) {
                if (j < seats(i).length && seats(i)(j) == '.') {
                    avail(i) |= (1 << j)
                }
            }
        }
        val full = 1 << n
        var best = Array.fill(full)(-1)
        best(0) = 0
        for (i <- 0 until m) {
            val ndp = Array.fill(full)(-1)
            for (mask <- 0 until full) {
                if ((mask & avail(i)) == mask && (mask & (mask << 1)) == 0) {
                    val pc = Integer.bitCount(mask)
                    for (pmask <- 0 until full) {
                        if (best(pmask) >= 0 && (mask & (pmask << 1)) == 0 && (mask & (pmask >> 1)) == 0) {
                            val v = best(pmask) + pc
                            if (v > ndp(mask)) ndp(mask) = v
                        }
                    }
                }
            }
            best = ndp
        }
        best.max
    }
}
