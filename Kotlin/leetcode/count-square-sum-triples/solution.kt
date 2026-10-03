import kotlin.math.sqrt

class Solution {
    fun countTriples(n: Int): Int {
        var count = 0
        for (a in 1..n) {
            for (b in a..n) {
                val cSquare = a * a + b * b
                val c = sqrt(cSquare.toDouble()).toInt()
                if (c <= n && c * c == cSquare) {
                    count += 2
                }
            }
        }
        return count
    }
}
