object Solution {
    def numSmallerByFrequency(queries: Array[String], words: Array[String]): Array[Int] = {
        def f(s: String): Int = {
            val minChar = s.min
            s.count(_ == minChar)
        }
        val wordFreqs = words.map(f).sorted
        val n = words.length
        queries.map { q =>
            val qf = f(q)
            var lo = 0
            var hi = wordFreqs.length
            while (lo < hi) {
                val mid = (lo + hi) / 2
                if (wordFreqs(mid) <= qf) lo = mid + 1 else hi = mid
            }
            n - lo
        }
    }
}
