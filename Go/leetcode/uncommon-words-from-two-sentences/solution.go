import "strings"

func uncommonFromSentences(s1 string, s2 string) []string {
	cnt := map[string]int{}
	for _, w := range strings.Fields(s1) {
		cnt[w]++
	}
	for _, w := range strings.Fields(s2) {
		cnt[w]++
	}
	res := []string{}
	for w, c := range cnt {
		if c == 1 {
			res = append(res, w)
		}
	}
	return res
}
