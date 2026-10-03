object Solution {
    def minStickers(stickers: Array[String], target: String): Int = {
        val n = target.length
        val full = (1 << n) - 1
        val INF = Int.MaxValue
        val dp = Array.fill(1 << n)(INF)
        dp(0) = 0
        val cnt = stickers.map { s =>
            val c = Array.fill(26)(0)
            for (ch <- s) c(ch - 'a') += 1
            c
        }
        for (state <- 0 until (1 << n)) {
            if (dp(state) != INF) {
                for (c <- cnt) {
                    val avail = c.clone()
                    var nxt = state
                    for (i <- 0 until n) {
                        if ((state & (1 << i)) == 0) {
                            val idx = target(i) - 'a'
                            if (avail(idx) > 0) {
                                avail(idx) -= 1
                                nxt |= (1 << i)
                            }
                        }
                    }
                    if (dp(state) + 1 < dp(nxt)) {
                        dp(nxt) = dp(state) + 1
                    }
                }
            }
        }
        if (dp(full) == INF) -1 else dp(full)
    }
}
