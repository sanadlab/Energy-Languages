import scala.collection.mutable

object Solution {
    def eventualSafeNodes(graph: Array[Array[Int]]): List[Int] = {
        val n = graph.length
        val rev = Array.fill(n)(mutable.ArrayBuffer[Int]())
        val outdeg = Array.fill(n)(0)
        for (u <- 0 until n) {
            for (v <- graph(u)) {
                if (v >= 0 && v < n) {
                    rev(v) += u
                    outdeg(u) += 1
                }
            }
        }
        val q = mutable.Queue[Int]()
        for (i <- 0 until n if outdeg(i) == 0) q.enqueue(i)
        val safe = Array.fill(n)(false)
        while (q.nonEmpty) {
            val v = q.dequeue()
            safe(v) = true
            for (u <- rev(v)) {
                outdeg(u) -= 1
                if (outdeg(u) == 0) q.enqueue(u)
            }
        }
        (0 until n).filter(safe(_)).toList
    }
}
