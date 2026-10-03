class Solution {
    fun maxStudents(seats: Array<CharArray>): Int {
        val m = seats.size
        if (m == 0) return 0
        val n = seats[0].size
        val avail = IntArray(m)
        for (i in 0 until m) {
            for (j in 0 until n) {
                if (j < seats[i].size && seats[i][j] == '.') {
                    avail[i] = avail[i] or (1 shl j)
                }
            }
        }
        val full = 1 shl n
        var best = IntArray(full) { -1 }
        best[0] = 0
        for (i in 0 until m) {
            val ndp = IntArray(full) { -1 }
            for (mask in 0 until full) {
                if ((mask and avail[i]) != mask) continue
                if ((mask and (mask shl 1)) != 0) continue
                val pc = Integer.bitCount(mask)
                for (pmask in 0 until full) {
                    if (best[pmask] < 0) continue
                    if ((mask and (pmask shl 1)) != 0) continue
                    if ((mask and (pmask shr 1)) != 0) continue
                    val v = best[pmask] + pc
                    if (v > ndp[mask]) ndp[mask] = v
                }
            }
            best = ndp
        }
        var ans = Int.MIN_VALUE
        for (v in best) if (v > ans) ans = v
        return ans
    }
}
