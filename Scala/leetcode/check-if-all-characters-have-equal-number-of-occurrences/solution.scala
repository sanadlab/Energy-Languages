object Solution {
    def areOccurrencesEqual(s: String): Boolean = {
        val counts = s.groupBy(identity).values.map(_.length).toSet
        counts.size == 1
    }
}
