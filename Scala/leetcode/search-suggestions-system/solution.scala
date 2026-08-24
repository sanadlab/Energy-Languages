object Solution {
    def suggestedProducts(products: Array[String], searchWord: String): List[List[String]] = {
        val ps = products.sorted
        val res = scala.collection.mutable.ListBuffer[List[String]]()
        for (l <- 1 to searchWord.length) {
            val pre = searchWord.substring(0, l)
            res += ps.filter(_.startsWith(pre)).take(3).toList
        }
        res.toList
    }
}
