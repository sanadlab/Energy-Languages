class Solution {
    fun maxPoints(points: Array<IntArray>): Int {
        val n = points.size
        if (n <= 2) return n
        var best = 1
        for (i in 0 until n) {
            val slopes = HashMap<Pair<Int, Int>, Int>()
            for (j in i + 1 until n) {
                var dx = points[j][0] - points[i][0]
                var dy = points[j][1] - points[i][1]
                val g = gcd(Math.abs(dx), Math.abs(dy))
                dx /= g
                dy /= g
                if (dx < 0 || (dx == 0 && dy < 0)) {
                    dx = -dx
                    dy = -dy
                }
                val key = Pair(dx, dy)
                val c = (slopes[key] ?: 0) + 1
                slopes[key] = c
                if (c + 1 > best) best = c + 1
            }
        }
        return best
    }

    private fun gcd(a: Int, b: Int): Int {
        var x = a
        var y = b
        while (y != 0) {
            val t = x % y
            x = y
            y = t
        }
        return x
    }
}
