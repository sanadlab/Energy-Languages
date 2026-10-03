object Solution {
    def uncommonFromSentences(s1: String, s2: String): Array[String] = {
        val allWords = (s1 + " " + s2).split("\\s+").filter(_.nonEmpty)
        val count = scala.collection.mutable.HashMap[String, Int]()
        for (w <- allWords) count(w) = count.getOrElse(w, 0) + 1
        allWords.distinct.filter(w => count(w) == 1)
    }
}
