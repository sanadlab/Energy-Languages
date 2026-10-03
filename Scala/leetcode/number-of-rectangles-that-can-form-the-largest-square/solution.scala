object Solution {
    def countGoodRectangles(rectangles: Array[Array[Int]]): Int = {
        var maxLen = 0
        var count = 0
        for (r <- rectangles) {
            val side = math.min(r(0), r(1))
            if (side > maxLen) {
                maxLen = side
                count = 1
            } else if (side == maxLen) {
                count += 1
            }
        }
        count
    }
}
