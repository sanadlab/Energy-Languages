import "sort"

func closeStrings(word1 string, word2 string) bool {
	if len(word1) != len(word2) {
		return false
	}
	var c1, c2 [26]int
	for _, ch := range word1 {
		c1[ch-'a']++
	}
	for _, ch := range word2 {
		c2[ch-'a']++
	}
	for i := 0; i < 26; i++ {
		if (c1[i] == 0) != (c2[i] == 0) {
			return false
		}
	}
	a := c1[:]
	b := c2[:]
	sort.Ints(a)
	sort.Ints(b)
	for i := 0; i < 26; i++ {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
