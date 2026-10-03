class Solution {
    fun isSumEqual(firstWord: String, secondWord: String, targetWord: String): Boolean {
        fun toNum(word: String): Long {
            var num = 0L
            for (c in word) num = num * 10 + (c - 'a')
            return num
        }
        return toNum(firstWord) + toNum(secondWord) == toNum(targetWord)
    }
}
