class Solution {
    fun countGoodRectangles(rectangles: Array<IntArray>): Int {
        var maxLen = 0
        var count = 0
        for (r in rectangles) {
            val side = minOf(r[0], r[1])
            if (side > maxLen) {
                maxLen = side
                count = 1
            } else if (side == maxLen) {
                count++
            }
        }
        return count
    }
}
