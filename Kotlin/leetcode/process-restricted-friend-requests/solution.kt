class Solution {
    fun friendRequests(n: Int, restrictions: Array<IntArray>, requests: Array<IntArray>): BooleanArray {
        val parent = IntArray(n) { it }
        fun find(x0: Int): Int {
            var x = x0
            while (parent[x] != x) {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }
        val res = BooleanArray(requests.size)
        for (i in requests.indices) {
            val u = requests[i][0]
            val v = requests[i][1]
            val pu = find(u)
            val pv = find(v)
            if (pu == pv) {
                res[i] = true
                continue
            }
            var ok = true
            for (r in restrictions) {
                val px = find(r[0])
                val py = find(r[1])
                if ((px == pu && py == pv) || (px == pv && py == pu)) {
                    ok = false
                    break
                }
            }
            if (ok) {
                parent[pu] = pv
                res[i] = true
            } else {
                res[i] = false
            }
        }
        return res
    }
}
