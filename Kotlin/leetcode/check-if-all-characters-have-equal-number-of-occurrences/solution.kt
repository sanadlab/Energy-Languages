class Solution {
    fun areOccurrencesEqual(s: String): Boolean {
        val counts = HashMap<Char, Int>()
        for (ch in s) {
            counts[ch] = (counts[ch] ?: 0) + 1
        }
        return counts.values.toSet().size == 1
    }
}
