object Solution {
    def checkStraightLine(coordinates: Array[Array[Int]]): Boolean = {
        val dx = coordinates(1)(0) - coordinates(0)(0)
        val dy = coordinates(1)(1) - coordinates(0)(1)
        var ok = true
        var i = 2
        while (i < coordinates.length) {
            val xDiff = coordinates(i)(0) - coordinates(0)(0)
            val yDiff = coordinates(i)(1) - coordinates(0)(1)
            if (dx.toLong * yDiff != dy.toLong * xDiff) ok = false
            i += 1
        }
        ok
    }
}
