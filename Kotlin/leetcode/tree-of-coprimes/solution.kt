class Solution {
    private fun gcd(a: Int, b: Int): Int {
        var x = a
        var y = b
        while (y != 0) {
            val t = x % y
            x = y
            y = t
        }
        return x
    }

    fun getCoprimes(nums: IntArray, edges: Array<IntArray>): IntArray {
        val n = nums.size
        val ans = IntArray(n) { -1 }
        val adj = Array(n) { ArrayList<Int>() }
        for (e in edges) {
            if (e.size < 2) continue
            val u = e[0]
            val v = e[1]
            if (u in 0 until n && v in 0 until n) {
                adj[u].add(v)
                adj[v].add(u)
            }
        }

        val coprime = Array(51) { ArrayList<Int>() }
        for (a in 1..50) {
            for (b in 1..50) {
                if (gcd(a, b) == 1) coprime[a].add(b)
            }
        }

        val depthStack = Array(51) { ArrayList<Int>() }
        val nodeStack = Array(51) { ArrayList<Int>() }
        if (n == 0) return ans

        val stack = ArrayList<IntArray>()
        stack.add(intArrayOf(0, -1, 0, 0))
        while (stack.isNotEmpty()) {
            val top = stack.removeAt(stack.size - 1)
            val node = top[0]
            val parent = top[1]
            val depth = top[2]
            val processed = top[3]
            val v = nums[node]
            if (processed == 1) {
                depthStack[v].removeAt(depthStack[v].size - 1)
                nodeStack[v].removeAt(nodeStack[v].size - 1)
                continue
            }
            var bestDepth = -1
            var bestNode = -1
            for (cv in coprime[v]) {
                val ds = depthStack[cv]
                if (ds.isNotEmpty() && ds[ds.size - 1] > bestDepth) {
                    bestDepth = ds[ds.size - 1]
                    bestNode = nodeStack[cv][nodeStack[cv].size - 1]
                }
            }
            ans[node] = bestNode
            stack.add(intArrayOf(node, parent, depth, 1))
            depthStack[v].add(depth)
            nodeStack[v].add(node)
            for (nb in adj[node]) {
                if (nb != parent) {
                    stack.add(intArrayOf(nb, node, depth + 1, 0))
                }
            }
        }
        return ans
    }
}
