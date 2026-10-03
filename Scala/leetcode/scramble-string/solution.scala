object Solution {
    def isScramble(s1: String, s2: String): Boolean = {
        if (s1.length != s2.length) return false
        val n = s1.length
        val dp = Array.fill(n + 1, n, n)(false)
        def checkEqual(i1: Int, i2: Int, length: Int): Boolean = {
            s1.substring(i1, i1 + length).sorted == s2.substring(i2, i2 + length).sorted
        }
        var length = 1
        while (length <= n) {
            var i = 0
            while (i <= n - length) {
                var j = 0
                while (j <= n - length) {
                    if (checkEqual(i, j, length)) {
                        if (length == 1) {
                            dp(length)(i)(j) = true
                        } else {
                            var k = 1
                            var done = false
                            while (k < length && !done) {
                                if ((dp(k)(i)(j) && dp(length - k)(i + k)(j + k)) ||
                                    (dp(k)(i)(j + length - k) && dp(length - k)(i + k)(j))) {
                                    dp(length)(i)(j) = true
                                    done = true
                                }
                                k += 1
                            }
                        }
                    }
                    j += 1
                }
                i += 1
            }
            length += 1
        }
        dp(n)(0)(0)
    }
}
