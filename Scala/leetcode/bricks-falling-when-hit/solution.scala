object Solution {
    def hitBricks(grid: Array[Array[Int]], hits: Array[Array[Int]]): Array[Int] = {
        val m = grid.length
        val n = if (m > 0) grid(0).length else 0
        val total = m * n
        val top = total
        val parent = Array.tabulate(total + 1)(i => i)
        val size = Array.fill(total + 1)(1)

        def find(x0: Int): Int = {
            var x = x0
            while (parent(x) != x) {
                parent(x) = parent(parent(x))
                x = parent(x)
            }
            x
        }

        def union(a: Int, b: Int): Unit = {
            var ra = find(a)
            var rb = find(b)
            if (ra != rb) {
                if (size(ra) < size(rb)) {
                    val t = ra; ra = rb; rb = t
                }
                parent(rb) = ra
                size(ra) += size(rb)
            }
        }

        def inBounds(r: Int, c: Int): Boolean = r >= 0 && r < m && c >= 0 && c < n

        val g = Array.fill(m, n)(0)
        for (r <- 0 until m; c <- 0 until n) {
            if (grid(r)(c) == 1) g(r)(c) = 1
        }

        for (h <- hits) {
            if (h.length >= 2 && inBounds(h(0), h(1))) g(h(0))(h(1)) = 0
        }

        for (r <- 0 until m; c <- 0 until n) {
            if (g(r)(c) == 1) {
                val cur = r * n + c
                if (r == 0) union(cur, top)
                if (r > 0 && g(r - 1)(c) == 1) union(cur, (r - 1) * n + c)
                if (c > 0 && g(r)(c - 1) == 1) union(cur, r * n + c - 1)
            }
        }

        val dirs = Array((1, 0), (-1, 0), (0, 1), (0, -1))
        val result = Array.fill(hits.length)(0)
        var i = hits.length - 1
        while (i >= 0) {
            val h = hits(i)
            if (h.length >= 2) {
                val r = h(0); val c = h(1)
                if (inBounds(r, c) && grid(r)(c) == 1) {
                    val before = size(find(top))
                    g(r)(c) = 1
                    val cur = r * n + c
                    if (r == 0) union(cur, top)
                    for ((dr, dc) <- dirs) {
                        val nr = r + dr; val nc = c + dc
                        if (inBounds(nr, nc) && g(nr)(nc) == 1) union(cur, nr * n + nc)
                    }
                    val after = size(find(top))
                    result(i) = math.max(0, after - before - 1)
                }
            }
            i -= 1
        }
        result
    }
}
