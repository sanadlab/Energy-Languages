class Solution {
    fun regionsBySlashes(grid: Array<String>): Int {
        val n = grid.size
        val parent = IntArray(4 * n * n) { it }

        fun find(x0: Int): Int {
            var x = x0
            while (parent[x] != x) {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }

        fun union(a: Int, b: Int) {
            val ra = find(a)
            val rb = find(b)
            if (ra != rb) parent[ra] = rb
        }

        for (r in 0 until n) {
            val row = grid[r]
            for (c in 0 until n) {
                val base = 4 * (r * n + c)
                val top = base
                val right = base + 1
                val bottom = base + 2
                val left = base + 3
                val ch = if (c < row.length) row[c] else ' '
                when (ch) {
                    '/' -> {
                        union(top, left)
                        union(right, bottom)
                    }
                    '\\' -> {
                        union(top, right)
                        union(left, bottom)
                    }
                    else -> {
                        union(top, right)
                        union(right, bottom)
                        union(bottom, left)
                    }
                }
                if (c + 1 < n) union(right, 4 * (r * n + c + 1) + 3)
                if (r + 1 < n) union(bottom, 4 * ((r + 1) * n + c))
            }
        }

        var count = 0
        for (i in 0 until 4 * n * n) if (find(i) == i) count++
        return count
    }
}
