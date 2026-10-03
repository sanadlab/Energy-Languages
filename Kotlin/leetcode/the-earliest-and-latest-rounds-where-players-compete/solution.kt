class Solution {
    private val memo = HashMap<Int, IntArray>()

    private fun dp(m: Int, fIn: Int, sIn: Int): IntArray {
        val key = m * 10000 + fIn * 100 + sIn
        memo[key]?.let { return it }
        var f = fIn
        var s = sIn
        if (f > s) {
            val t = f; f = s; s = t
        }
        if (f + s == m + 1) {
            val r = intArrayOf(1, 1)
            memo[key] = r
            return r
        }
        val newM = (m + 1) / 2
        val groups = ArrayList<IntArray>()
        for (p in 1..m / 2) {
            val q = m + 1 - p
            if (f == p || f == q) {
                groups.add(intArrayOf(f))
            } else if (s == p || s == q) {
                groups.add(intArrayOf(s))
            } else {
                groups.add(intArrayOf(p, q))
            }
        }
        if (m % 2 == 1) {
            groups.add(intArrayOf((m + 1) / 2))
        }

        val outcomes = HashSet<Int>()
        fun enumerate(idx: Int, belowF: Int, belowS: Int) {
            if (idx == groups.size) {
                outcomes.add((belowF + 1) * 100 + (belowS + 1))
                return
            }
            for (w in groups[idx]) {
                enumerate(
                    idx + 1,
                    belowF + if (w < f) 1 else 0,
                    belowS + if (w < s) 1 else 0
                )
            }
        }
        enumerate(0, 0, 0)

        var earliest = Int.MAX_VALUE
        var latest = Int.MIN_VALUE
        for (oc in outcomes) {
            val nf = oc / 100
            val ns = oc % 100
            val r = dp(newM, nf, ns)
            if (r[0] + 1 < earliest) earliest = r[0] + 1
            if (r[1] + 1 > latest) latest = r[1] + 1
        }
        val result = intArrayOf(earliest, latest)
        memo[key] = result
        return result
    }

    fun earliestAndLatest(n: Int, firstPlayer: Int, secondPlayer: Int): IntArray {
        memo.clear()
        val r = dp(n, firstPlayer, secondPlayer)
        return intArrayOf(r[0], r[1])
    }
}
