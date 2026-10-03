class Solution {
    fun canBeTypedWords(text: String, brokenLetters: String): Int {
        val broken = brokenLetters.toSet()
        var count = 0
        for (word in text.split(" ")) {
            if (word.isEmpty()) continue
            if (word.none { it in broken }) count += 1
        }
        return count
    }
}
