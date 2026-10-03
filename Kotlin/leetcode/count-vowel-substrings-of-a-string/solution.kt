class Solution {
    fun countVowelSubstrings(word: String): Int {
        val vowels = "aeiou"
        var count = 0
        val n = word.length

        for (i in 0 until n) {
            if (word[i] !in vowels) {
                continue
            }
            val seenVowels = HashSet<Char>()
            var j = i
            while (j < n && word[j] in vowels) {
                seenVowels.add(word[j])
                if (seenVowels.size == 5) {
                    count++
                }
                j++
            }
        }

        return count
    }
}
