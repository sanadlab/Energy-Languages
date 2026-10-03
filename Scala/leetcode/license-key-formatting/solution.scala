object Solution {
    def licenseKeyFormatting(s: String, k: Int): String = {
        val cleaned = s.replace("-", "").toUpperCase
        val firstGroupLen = cleaned.length % k
        val result = scala.collection.mutable.ListBuffer[String]()
        if (firstGroupLen > 0) result += cleaned.substring(0, firstGroupLen)
        var i = firstGroupLen
        while (i < cleaned.length) {
            result += cleaned.substring(i, math.min(i + k, cleaned.length))
            i += k
        }
        result.mkString("-")
    }
}
