object Solution {
    def nextBeautifulNumber(n: Int): Int = {
        var x = n + 1
        var result = -1
        while (result < 0) {
            val cnt = Array.fill(10)(0)
            var t = x
            while (t > 0) {
                cnt(t % 10) += 1
                t /= 10
            }
            var ok = true
            var d = 0
            while (d < 10) {
                if (cnt(d) != 0 && cnt(d) != d) ok = false
                d += 1
            }
            if (ok) result = x
            x += 1
        }
        result
    }
}
