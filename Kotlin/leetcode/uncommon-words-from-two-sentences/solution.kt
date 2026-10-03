class Solution {
    fun uncommonFromSentences(s1: String, s2: String): Array<String> {
        val allWords = (s1 + " " + s2).trim().split(" ").filter { it.isNotEmpty() }
        val wordCount = LinkedHashMap<String, Int>()
        for (word in allWords) {
            wordCount[word] = (wordCount[word] ?: 0) + 1
        }
        val uncommonWords = ArrayList<String>()
        for ((word, count) in wordCount) {
            if (count == 1) {
                uncommonWords.add(word)
            }
        }
        return uncommonWords.toTypedArray()
    }
}
