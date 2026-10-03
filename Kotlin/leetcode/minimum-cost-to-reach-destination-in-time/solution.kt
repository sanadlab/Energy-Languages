class Solution {
    fun minCost(maxTime: Int, edges: Array<IntArray>, passingFees: IntArray): Int {
        val n = passingFees.size
        val INF = 1 shl 29
        val adj = Array(n) { mutableListOf<IntArray>() }
        for (e in edges) {
            if (e.size < 3) continue
            val x = e[0]
            val y = e[1]
            val w = e[2]
            if (x < 0 || x >= n || y < 0 || y >= n || w < 0) continue
            adj[x].add(intArrayOf(y, w))
            adj[y].add(intArrayOf(x, w))
        }
        val dp = Array(maxTime + 1) { IntArray(n) { INF } }
        dp[0][0] = passingFees[0]
        var ans = INF
        for (t in 0..maxTime) {
            val row = dp[t]
            for (u in 0 until n) {
                val cur = row[u]
                if (cur >= INF) continue
                if (u == n - 1 && cur < ans) ans = cur
                for (e in adj[u]) {
                    val v = e[0]
                    val w = e[1]
                    val nt = t + w
                    if (nt <= maxTime && cur + passingFees[v] < dp[nt][v]) {
                        dp[nt][v] = cur + passingFees[v]
                    }
                }
            }
        }
        return if (ans >= INF) -1 else ans
    }
}
