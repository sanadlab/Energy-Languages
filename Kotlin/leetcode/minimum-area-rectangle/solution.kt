class Solution {
    fun minAreaRect(points: Array<IntArray>): Int {
        val seen = HashSet<Int>()
        val n = points.size
        for (p in points) seen.add(p[0] * 50000 + p[1])
        var best = Int.MAX_VALUE
        for (i in 0 until n) {
            val x1 = points[i][0]
            val y1 = points[i][1]
            for (j in i + 1 until n) {
                val x2 = points[j][0]
                val y2 = points[j][1]
                if (x1 != x2 && y1 != y2) {
                    if ((x1 * 50000 + y2) in seen && (x2 * 50000 + y1) in seen) {
                        val area = Math.abs(x1 - x2) * Math.abs(y1 - y2)
                        if (area < best) best = area
                    }
                }
            }
        }
        return if (best == Int.MAX_VALUE) 0 else best
    }
}
