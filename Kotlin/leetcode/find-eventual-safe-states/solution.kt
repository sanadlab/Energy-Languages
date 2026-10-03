class Solution {
    fun eventualSafeNodes(graph: Array<IntArray>): List<Int> {
        val n = graph.size
        val rev = Array(n) { ArrayList<Int>() }
        val outdeg = IntArray(n)
        for (u in 0 until n) {
            for (v in graph[u]) {
                if (v in 0 until n) {
                    rev[v].add(u)
                    outdeg[u]++
                }
            }
        }
        val q = ArrayDeque<Int>()
        for (i in 0 until n) {
            if (outdeg[i] == 0) {
                q.addLast(i)
            }
        }
        val safe = BooleanArray(n)
        while (q.isNotEmpty()) {
            val v = q.removeFirst()
            safe[v] = true
            for (u in rev[v]) {
                outdeg[u]--
                if (outdeg[u] == 0) {
                    q.addLast(u)
                }
            }
        }
        val result = ArrayList<Int>()
        for (i in 0 until n) {
            if (safe[i]) {
                result.add(i)
            }
        }
        return result
    }
}
