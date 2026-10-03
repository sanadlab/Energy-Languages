class Solution {
    fun closeStrings(word1: String, word2: String): Boolean {
        if (word1.length != word2.length) {
            return false
        }

        val freq1 = IntArray(26)
        val freq2 = IntArray(26)

        for (i in word1.indices) {
            freq1[word1[i] - 'a']++
            freq2[word2[i] - 'a']++
        }

        for (i in 0 until 26) {
            if ((freq1[i] > 0 && freq2[i] == 0) || (freq2[i] > 0 && freq1[i] == 0)) {
                return false
            }
        }

        return freq1.sorted() == freq2.sorted()
    }
}
