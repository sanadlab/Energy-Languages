import scala.collection.mutable

object Solution {
    def minCost(maxTime: Int, edges: Array[Array[Int]], passingFees: Array[Int]): Int = {
        val n = passingFees.length
        val INF = 1 << 29
        val adj = Array.fill(n)(mutable.ArrayBuffer[(Int, Int)]())
        for (e <- edges) {
            if (e.length >= 3) {
                val x = e(0); val y = e(1); val w = e(2)
                if (x >= 0 && x < n && y >= 0 && y < n && w >= 0) {
                    adj(x) += ((y, w))
                    adj(y) += ((x, w))
                }
            }
        }
        val dp = Array.fill(maxTime + 1, n)(INF)
        dp(0)(0) = passingFees(0)
        var ans = INF
        for (t <- 0 to maxTime) {
            val row = dp(t)
            for (u <- 0 until n) {
                val cur = row(u)
                if (cur < INF) {
                    if (u == n - 1 && cur < ans) ans = cur
                    for ((v, w) <- adj(u)) {
                        val nt = t + w
                        if (nt <= maxTime && cur + passingFees(v) < dp(nt)(v)) {
                            dp(nt)(v) = cur + passingFees(v)
                        }
                    }
                }
            }
        }
        if (ans >= INF) -1 else ans
    }
}
