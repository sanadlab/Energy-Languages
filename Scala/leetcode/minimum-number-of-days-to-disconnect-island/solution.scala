object Solution {
    def minDays(grid: Array[Array[Int]]): Int = {
        val rows = grid.length
        val cols = grid(0).length
        def countIslands(): Int = {
            val visited = Array.fill(rows, cols)(false)
            var count = 0
            for (i <- 0 until rows; j <- 0 until cols) {
                if (grid(i)(j) == 1 && !visited(i)(j)) {
                    count += 1
                    val stack = scala.collection.mutable.ArrayBuffer[(Int, Int)]()
                    stack += ((i, j))
                    visited(i)(j) = true
                    while (stack.nonEmpty) {
                        val (x, y) = stack.remove(stack.length - 1)
                        for ((dx, dy) <- List((1, 0), (-1, 0), (0, 1), (0, -1))) {
                            val nx = x + dx
                            val ny = y + dy
                            if (nx >= 0 && nx < rows && ny >= 0 && ny < cols && grid(nx)(ny) == 1 && !visited(nx)(ny)) {
                                visited(nx)(ny) = true
                                stack += ((nx, ny))
                            }
                        }
                    }
                }
            }
            count
        }
        if (countIslands() != 1) return 0
        var result = 2
        var i = 0
        while (i < rows && result == 2) {
            var j = 0
            while (j < cols && result == 2) {
                if (grid(i)(j) == 1) {
                    grid(i)(j) = 0
                    if (countIslands() != 1) {
                        result = 1
                    }
                    grid(i)(j) = 1
                }
                j += 1
            }
            i += 1
        }
        result
    }
}
