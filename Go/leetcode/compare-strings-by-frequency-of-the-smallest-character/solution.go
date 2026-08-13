func numSmallerByFrequency(queries []string, words []string) []int {
	f := func(s string) int {
		mn := byte('z')
		cnt := 0
		for i := 0; i < len(s); i++ {
			c := s[i]
			if c < mn {
				mn = c
				cnt = 1
			} else if c == mn {
				cnt++
			}
		}
		return cnt
	}
	wf := make([]int, len(words))
	for i, w := range words {
		wf[i] = f(w)
	}
	ans := make([]int, len(queries))
	for i, q := range queries {
		fq := f(q)
		c := 0
		for _, v := range wf {
			if v > fq {
				c++
			}
		}
		ans[i] = c
	}
	return ans
}
