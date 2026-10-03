object Solution {
    def countVowelSubstrings(word: String): Int = {
        val vowels = Set('a', 'e', 'i', 'o', 'u')
        var count = 0
        val n = word.length
        var i = 0
        while (i < n) {
            if (vowels.contains(word(i))) {
                val seen = scala.collection.mutable.Set[Char]()
                var j = i
                while (j < n && vowels.contains(word(j))) {
                    seen.add(word(j))
                    if (seen.size == 5) count += 1
                    j += 1
                }
            }
            i += 1
        }
        count
    }
}
