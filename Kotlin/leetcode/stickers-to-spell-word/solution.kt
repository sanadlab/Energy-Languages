class Solution {
    fun minStickers(stickers: Array<String>, target: String): Int {
        val n = target.length
        val full = (1 shl n) - 1
        val INF = Int.MAX_VALUE
        val dp = IntArray(1 shl n) { INF }
        dp[0] = 0
        val cnt = ArrayList<IntArray>()
        for (s in stickers) {
            val c = IntArray(26)
            for (ch in s) c[ch - 'a']++
            cnt.add(c)
        }
        for (state in 0 until (1 shl n)) {
            if (dp[state] == INF) continue
            for (c in cnt) {
                val avail = c.copyOf()
                var nxt = state
                for (i in 0 until n) {
                    if (state and (1 shl i) == 0) {
                        val idx = target[i] - 'a'
                        if (avail[idx] > 0) {
                            avail[idx]--
                            nxt = nxt or (1 shl i)
                        }
                    }
                }
                if (dp[state] + 1 < dp[nxt]) {
                    dp[nxt] = dp[state] + 1
                }
            }
        }
        return if (dp[full] == INF) -1 else dp[full]
    }
}
