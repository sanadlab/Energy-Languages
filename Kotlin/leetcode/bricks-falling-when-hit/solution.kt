class Solution {
    fun hitBricks(grid: Array<IntArray>, hits: Array<IntArray>): IntArray {
        val m = grid.size
        val n = if (m > 0) grid[0].size else 0
        val total = m * n
        val top = total
        val parent = IntArray(total + 1) { it }
        val size = IntArray(total + 1) { 1 }

        fun find(x0: Int): Int {
            var x = x0
            while (parent[x] != x) {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }

        fun union(a: Int, b: Int) {
            var ra = find(a)
            var rb = find(b)
            if (ra == rb) return
            if (size[ra] < size[rb]) {
                val t = ra; ra = rb; rb = t
            }
            parent[rb] = ra
            size[ra] += size[rb]
        }

        fun inBounds(r: Int, c: Int): Boolean = r in 0 until m && c in 0 until n

        val g = Array(m) { IntArray(n) }
        for (r in 0 until m) {
            for (c in 0 until n) {
                if (grid[r][c] == 1) g[r][c] = 1
            }
        }

        for (h in hits) {
            if (h.size >= 2 && inBounds(h[0], h[1])) {
                g[h[0]][h[1]] = 0
            }
        }

        for (r in 0 until m) {
            for (c in 0 until n) {
                if (g[r][c] == 1) {
                    val cur = r * n + c
                    if (r == 0) union(cur, top)
                    if (r > 0 && g[r - 1][c] == 1) union(cur, (r - 1) * n + c)
                    if (c > 0 && g[r][c - 1] == 1) union(cur, r * n + c - 1)
                }
            }
        }

        val dirs = arrayOf(intArrayOf(1, 0), intArrayOf(-1, 0), intArrayOf(0, 1), intArrayOf(0, -1))
        val result = IntArray(hits.size)
        for (i in hits.size - 1 downTo 0) {
            val h = hits[i]
            if (h.size < 2) continue
            val r = h[0]
            val c = h[1]
            if (!inBounds(r, c)) continue
            if (grid[r][c] != 1) continue
            val before = size[find(top)]
            g[r][c] = 1
            val cur = r * n + c
            if (r == 0) union(cur, top)
            for (d in dirs) {
                val nr = r + d[0]
                val nc = c + d[1]
                if (inBounds(nr, nc) && g[nr][nc] == 1) union(cur, nr * n + nc)
            }
            val after = size[find(top)]
            result[i] = maxOf(0, after - before - 1)
        }
        return result
    }
}
