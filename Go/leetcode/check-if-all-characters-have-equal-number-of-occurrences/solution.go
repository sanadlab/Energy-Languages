func areOccurrencesEqual(s string) bool {
	cnt := make(map[rune]int)
	for _, c := range s {
		cnt[c]++
	}
	f := -1
	for _, v := range cnt {
		if f == -1 {
			f = v
		} else if v != f {
			return false
		}
	}
	return true
}
