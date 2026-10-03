class Solution {
    fun restoreArray(adjacentPairs: Array<IntArray>): IntArray {
        val adj = LinkedHashMap<Int, MutableList<Int>>()
        for (pair in adjacentPairs) {
            val u = pair[0]
            val v = pair[1]
            adj.getOrPut(u) { mutableListOf() }.add(v)
            adj.getOrPut(v) { mutableListOf() }.add(u)
        }
        val n = adjacentPairs.size + 1
        var start = if (adjacentPairs.isNotEmpty()) adjacentPairs[0][0] else 0
        for ((node, nbrs) in adj) {
            if (nbrs.size == 1) {
                start = node
                break
            }
        }
        val res = ArrayList<Int>()
        res.add(start)
        var prev = start
        var cur = start
        var hasPrev = false
        while (res.size < n) {
            var nxt: Int? = null
            for (x in adj[cur]!!) {
                if (!hasPrev || x != prev) {
                    nxt = x
                    break
                }
            }
            if (nxt == null) break
            res.add(nxt)
            prev = cur
            hasPrev = true
            cur = nxt
        }
        return res.toIntArray()
    }
}
