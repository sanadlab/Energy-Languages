object Solution {
    def regionsBySlashes(grid: Array[String]): Int = {
        val n = grid.length
        val parent = Array.tabulate(4 * n * n)(i => i)
        def find(x0: Int): Int = {
            var x = x0
            while (parent(x) != x) {
                parent(x) = parent(parent(x))
                x = parent(x)
            }
            x
        }
        def union(a: Int, b: Int): Unit = {
            val ra = find(a); val rb = find(b)
            if (ra != rb) parent(ra) = rb
        }
        for (r <- 0 until n) {
            val row = grid(r)
            for (c <- 0 until n) {
                val base = 4 * (r * n + c)
                val top = base; val right = base + 1; val bottom = base + 2; val left = base + 3
                val ch = if (c < row.length) row.charAt(c) else ' '
                if (ch == '/') {
                    union(top, left); union(right, bottom)
                } else if (ch == '\\') {
                    union(top, right); union(left, bottom)
                } else {
                    union(top, right); union(right, bottom); union(bottom, left)
                }
                if (c + 1 < n) union(right, 4 * (r * n + c + 1) + 3)
                if (r + 1 < n) union(bottom, 4 * ((r + 1) * n + c))
            }
        }
        (0 until 4 * n * n).count(i => find(i) == i)
    }
}
