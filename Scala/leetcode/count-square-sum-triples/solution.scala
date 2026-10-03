object Solution {
    def countTriples(n: Int): Int = {
        var count = 0
        for (a <- 1 to n) {
            for (b <- a to n) {
                val cSquare = a * a + b * b
                val c = math.round(math.sqrt(cSquare.toDouble)).toInt
                if (c <= n && c * c == cSquare) {
                    count += 2
                }
            }
        }
        count
    }
}
