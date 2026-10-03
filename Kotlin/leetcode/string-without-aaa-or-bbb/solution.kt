class Solution {
    fun strWithout3a3b(a: Int, b: Int): String {
        var a = a
        var b = b
        val res = StringBuilder()
        while (a > 0 || b > 0) {
            val n = res.length
            val writeA: Boolean = if (n >= 2 && res[n - 1] == res[n - 2]) {
                res[n - 1] == 'b'
            } else {
                a >= b
            }
            if (writeA) {
                if (a == 0) break
                res.append('a'); a--
            } else {
                if (b == 0) break
                res.append('b'); b--
            }
        }
        return res.toString()
    }
}
