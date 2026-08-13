import "sort"

func longestStrChain(words []string) int {
	sort.Slice(words, func(i, j int) bool { return len(words[i]) < len(words[j]) })
	dp := make(map[string]int)
	best := 1
	for _, w := range words {
		cur := 1
		for i := 0; i < len(w); i++ {
			pred := w[:i] + w[i+1:]
			if v, ok := dp[pred]; ok && v+1 > cur {
				cur = v + 1
			}
		}
		dp[w] = cur
		if cur > best {
			best = cur
		}
	}
	return best
}
