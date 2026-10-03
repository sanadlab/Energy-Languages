object Solution {
    def minAreaRect(points: Array[Array[Int]]): Int = {
        val seen = scala.collection.mutable.HashSet[Long]()
        val n = points.length
        for (p <- points) seen += p(0).toLong * 50000 + p(1)
        var best = Int.MaxValue
        var i = 0
        while (i < n) {
            val x1 = points(i)(0); val y1 = points(i)(1)
            var j = i + 1
            while (j < n) {
                val x2 = points(j)(0); val y2 = points(j)(1)
                if (x1 != x2 && y1 != y2) {
                    if (seen.contains(x1.toLong * 50000 + y2) && seen.contains(x2.toLong * 50000 + y1)) {
                        val area = math.abs(x1 - x2) * math.abs(y1 - y2)
                        if (area < best) best = area
                    }
                }
                j += 1
            }
            i += 1
        }
        if (best == Int.MaxValue) 0 else best
    }
}
