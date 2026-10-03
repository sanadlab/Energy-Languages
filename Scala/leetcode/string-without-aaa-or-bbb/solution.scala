object Solution {
    def strWithout3a3b(a: Int, b: Int): String = {
        var ca = a
        var cb = b
        val res = new StringBuilder
        var stop = false
        while ((ca > 0 || cb > 0) && !stop) {
            val n = res.length
            val writeA =
                if (n >= 2 && res(n - 1) == res(n - 2)) res(n - 1) == 'b'
                else ca >= cb
            if (writeA) {
                if (ca == 0) stop = true
                else { res.append('a'); ca -= 1 }
            } else {
                if (cb == 0) stop = true
                else { res.append('b'); cb -= 1 }
            }
        }
        res.toString
    }
}
