class Solution {
    fun longestStrChain(words: Array<String>): Int {
        words.sortBy { it.length }
        val dp = HashMap<String, Int>()
        var best = 1
        for (w in words) {
            var cur = 1
            for (i in w.indices) {
                val pred = w.substring(0, i) + w.substring(i + 1)
                val p = dp[pred]
                if (p != null) {
                    cur = maxOf(cur, p + 1)
                }
            }
            dp[w] = cur
            best = maxOf(best, cur)
        }
        return best
    }
}
