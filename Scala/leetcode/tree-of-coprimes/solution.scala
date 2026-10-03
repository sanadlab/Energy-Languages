import scala.collection.mutable

object Solution {
    def getCoprimes(nums: Array[Int], edges: Array[Array[Int]]): Array[Int] = {
        val n = nums.length
        val ans = Array.fill(n)(-1)
        val adj = Array.fill(n)(mutable.ArrayBuffer[Int]())
        for (e <- edges) {
            if (e.length >= 2) {
                val u = e(0); val v = e(1)
                if (u >= 0 && u < n && v >= 0 && v < n) {
                    adj(u) += v
                    adj(v) += u
                }
            }
        }

        def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

        val coprime = Array.fill(51)(mutable.ArrayBuffer[Int]())
        for (a <- 1 to 50; b <- 1 to 50) {
            if (gcd(a, b) == 1) coprime(a) += b
        }

        val depthStack = Array.fill(51)(mutable.ArrayBuffer[Int]())
        val nodeStack = Array.fill(51)(mutable.ArrayBuffer[Int]())
        if (n == 0) return ans

        val stack = mutable.ArrayBuffer[(Int, Int, Int, Boolean)]()
        stack += ((0, -1, 0, false))
        while (stack.nonEmpty) {
            val (node, parent, depth, processed) = stack.remove(stack.length - 1)
            val value = nums(node)
            if (processed) {
                depthStack(value).remove(depthStack(value).length - 1)
                nodeStack(value).remove(nodeStack(value).length - 1)
            } else {
                var bestDepth = -1
                var bestNode = -1
                for (cv <- coprime(value)) {
                    val ds = depthStack(cv)
                    if (ds.nonEmpty && ds.last > bestDepth) {
                        bestDepth = ds.last
                        bestNode = nodeStack(cv).last
                    }
                }
                ans(node) = bestNode
                stack += ((node, parent, depth, true))
                depthStack(value) += depth
                nodeStack(value) += node
                for (nb <- adj(node)) {
                    if (nb != parent) stack += ((nb, node, depth + 1, false))
                }
            }
        }
        ans
    }
}
