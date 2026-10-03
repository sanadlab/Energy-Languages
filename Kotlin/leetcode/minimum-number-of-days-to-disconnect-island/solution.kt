class Solution {
    fun minDays(grid: Array<IntArray>): Int {
        val rows = grid.size
        val cols = grid[0].size
        val dirs = arrayOf(intArrayOf(1, 0), intArrayOf(-1, 0), intArrayOf(0, 1), intArrayOf(0, -1))

        fun countIslands(): Int {
            val visited = Array(rows) { BooleanArray(cols) }
            var count = 0
            for (i in 0 until rows) {
                for (j in 0 until cols) {
                    if (grid[i][j] == 1 && !visited[i][j]) {
                        count++
                        val stack = ArrayDeque<IntArray>()
                        stack.addLast(intArrayOf(i, j))
                        visited[i][j] = true
                        while (stack.isNotEmpty()) {
                            val p = stack.removeLast()
                            val x = p[0]
                            val y = p[1]
                            for (d in dirs) {
                                val nx = x + d[0]
                                val ny = y + d[1]
                                if (nx in 0 until rows && ny in 0 until cols && grid[nx][ny] == 1 && !visited[nx][ny]) {
                                    visited[nx][ny] = true
                                    stack.addLast(intArrayOf(nx, ny))
                                }
                            }
                        }
                    }
                }
            }
            return count
        }

        if (countIslands() != 1) return 0
        for (i in 0 until rows) {
            for (j in 0 until cols) {
                if (grid[i][j] == 1) {
                    grid[i][j] = 0
                    if (countIslands() != 1) {
                        grid[i][j] = 1
                        return 1
                    }
                    grid[i][j] = 1
                }
            }
        }
        return 2
    }
}
