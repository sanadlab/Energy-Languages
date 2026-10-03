class Solution {
    fun nextBeautifulNumber(n: Int): Int {
        var x = n + 1
        while (true) {
            val cnt = IntArray(10)
            var t = x
            while (t > 0) {
                cnt[t % 10]++
                t /= 10
            }
            var ok = true
            for (d in 0 until 10) {
                if (cnt[d] != 0 && cnt[d] != d) {
                    ok = false
                    break
                }
            }
            if (ok) return x
            x++
        }
    }
}
