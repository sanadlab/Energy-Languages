object Solution {
    def xorOperation(n: Int, start: Int): Int = {
        var result = 0
        for (i <- 0 until n) {
            result ^= (start + 2 * i)
        }
        result
    }
}
