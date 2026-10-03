import scala.collection.mutable

object Solution {
    def longestStrChain(words: Array[String]): Int = {
        val sorted = words.sortBy(_.length)
        val dp = mutable.HashMap[String, Int]()
        var best = 1
        for (w <- sorted) {
            var cur = 1
            for (i <- 0 until w.length) {
                val pred = w.substring(0, i) + w.substring(i + 1)
                dp.get(pred) match {
                    case Some(v) => cur = math.max(cur, v + 1)
                    case None =>
                }
            }
            dp(w) = cur
            best = math.max(best, cur)
        }
        best
    }
}
