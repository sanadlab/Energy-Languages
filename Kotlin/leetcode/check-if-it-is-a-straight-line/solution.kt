class Solution {
    fun checkStraightLine(coordinates: Array<IntArray>): Boolean {
        val dx = coordinates[1][0] - coordinates[0][0]
        val dy = coordinates[1][1] - coordinates[0][1]
        for (i in 2 until coordinates.size) {
            val xDiff = coordinates[i][0] - coordinates[0][0]
            val yDiff = coordinates[i][1] - coordinates[0][1]
            if (dx * yDiff != dy * xDiff) return false
        }
        return true
    }
}
