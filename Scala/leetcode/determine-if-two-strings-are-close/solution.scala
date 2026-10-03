object Solution {
    def closeStrings(word1: String, word2: String): Boolean = {
        if (word1.length != word2.length) false
        else {
            val freq1 = Array.fill(26)(0)
            val freq2 = Array.fill(26)(0)
            for (i <- word1.indices) {
                freq1(word1(i) - 'a') += 1
                freq2(word2(i) - 'a') += 1
            }
            var ok = true
            for (i <- 0 until 26) {
                if ((freq1(i) > 0 && freq2(i) == 0) || (freq2(i) > 0 && freq1(i) == 0)) ok = false
            }
            ok && freq1.sorted.sameElements(freq2.sorted)
        }
    }
}
