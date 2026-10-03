class Solution {
    fun numSmallerByFrequency(queries: Array<String>, words: Array<String>): IntArray {
        fun f(s: String): Int {
            var minC = s[0]
            for (c in s) if (c < minC) minC = c
            var cnt = 0
            for (c in s) if (c == minC) cnt++
            return cnt
        }
        val wordFreqs = IntArray(words.size) { f(words[it]) }
        wordFreqs.sort()
        val res = IntArray(queries.size)
        for (qi in queries.indices) {
            val target = f(queries[qi]) + 1
            // lower bound of `target` in wordFreqs
            var lo = 0
            var hi = wordFreqs.size
            while (lo < hi) {
                val mid = (lo + hi) ushr 1
                if (wordFreqs[mid] < target) lo = mid + 1 else hi = mid
            }
            res[qi] = words.size - lo
        }
        return res
    }
}
