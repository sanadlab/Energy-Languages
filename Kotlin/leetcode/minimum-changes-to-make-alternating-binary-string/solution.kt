class Solution {
    fun minOperations(s: String): Int {
        var cnt = 0
        val n = s.length
        for (i in 0 until n) {
            val expected = if (i % 2 == 0) '0' else '1'
            if (s[i] != expected) cnt++
        }
        return minOf(cnt, n - cnt)
    }
}
