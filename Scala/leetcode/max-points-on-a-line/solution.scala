object Solution {
    def maxPoints(points: Array[Array[Int]]): Int = {
        val n = points.length
        if (n <= 2) return n
        def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)
        var best = 1
        var i = 0
        while (i < n) {
            val slopes = scala.collection.mutable.HashMap[(Int, Int), Int]()
            var j = i + 1
            while (j < n) {
                var dx = points(j)(0) - points(i)(0)
                var dy = points(j)(1) - points(i)(1)
                val g = gcd(math.abs(dx), math.abs(dy))
                dx /= g
                dy /= g
                if (dx < 0 || (dx == 0 && dy < 0)) { dx = -dx; dy = -dy }
                val key = (dx, dy)
                val c = slopes.getOrElse(key, 0) + 1
                slopes(key) = c
                if (c + 1 > best) best = c + 1
                j += 1
            }
            i += 1
        }
        best
    }
}
