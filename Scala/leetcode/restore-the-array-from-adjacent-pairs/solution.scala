object Solution {
    def restoreArray(adjacentPairs: Array[Array[Int]]): Array[Int] = {
        val adj = scala.collection.mutable.HashMap[Int, scala.collection.mutable.ArrayBuffer[Int]]()
        for (pair <- adjacentPairs) {
            val u = pair(0); val v = pair(1)
            adj.getOrElseUpdate(u, scala.collection.mutable.ArrayBuffer[Int]()) += v
            adj.getOrElseUpdate(v, scala.collection.mutable.ArrayBuffer[Int]()) += u
        }
        val n = adjacentPairs.length + 1
        var start = if (adjacentPairs.nonEmpty) adjacentPairs(0)(0) else 0
        val it = adj.iterator
        var found = false
        while (it.hasNext && !found) {
            val (node, nbrs) = it.next()
            if (nbrs.length == 1) { start = node; found = true }
        }
        val res = scala.collection.mutable.ArrayBuffer[Int](start)
        var prev = start
        var cur = start
        var hasPrev = false
        while (res.length < n) {
            var nxt: Option[Int] = None
            val nbrs = adj(cur)
            var idx = 0
            while (idx < nbrs.length && nxt.isEmpty) {
                val x = nbrs(idx)
                if (!hasPrev || x != prev) nxt = Some(x)
                idx += 1
            }
            nxt match {
                case Some(x) =>
                    res += x
                    prev = cur
                    hasPrev = true
                    cur = x
                case None =>
                    return res.toArray
            }
        }
        res.toArray
    }
}
