object Solution {
    def isSumEqual(firstWord: String, secondWord: String, targetWord: String): Boolean = {
        def wordToNum(word: String): Int = word.foldLeft(0)((num, ch) => num * 10 + (ch - 'a'))
        wordToNum(firstWord) + wordToNum(secondWord) == wordToNum(targetWord)
    }
}
