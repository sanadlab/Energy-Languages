package solution

func countVowelSubstrings(word string) int {
    isVowel := func(c byte) bool {
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'
    }

    count := 0
    n := len(word)
    for i := 0; i < n; i++ {
        if !isVowel(word[i]) {
            continue
        }
        seen := map[byte]bool{}
        for j := i; j < n && isVowel(word[j]); j++ {
            seen[word[j]] = true
            if len(seen) == 5 {
                count++
            }
        }
    }

    return count
}