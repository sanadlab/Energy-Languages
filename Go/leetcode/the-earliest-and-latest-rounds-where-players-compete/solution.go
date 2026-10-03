func earliestAndLatest(n int, firstPlayer int, secondPlayer int) []int {
	const INF = 1 << 30
	memo := map[[3]int][2]int{}
	var dp func(m, f, s int) [2]int
	dp = func(m, f, s int) [2]int {
		if f > s {
			f, s = s, f
		}
		// The two players meet this round iff they are paired together.
		if f+s == m+1 {
			return [2]int{1, 1}
		}
		key := [3]int{m, f, s}
		if v, ok := memo[key]; ok {
			return v
		}
		newM := (m + 1) / 2
		// Each group is the set of possible winners of one pairing (p vs q).
		var groups [][]int
		for p := 1; p <= m/2; p++ {
			q := m + 1 - p
			if f == p || f == q {
				groups = append(groups, []int{f}) // firstPlayer always wins its match
			} else if s == p || s == q {
				groups = append(groups, []int{s}) // secondPlayer always wins its match
			} else {
				groups = append(groups, []int{p, q}) // either side may be chosen to win
			}
		}
		if m%2 == 1 {
			groups = append(groups, []int{(m + 1) / 2}) // middle player auto-advances
		}
		// Enumerate every combination of winners; the new ranks of f and s are
		// the counts of winners below them, plus one.
		outcomes := map[[2]int]bool{}
		var rec func(idx, belowF, belowS int)
		rec = func(idx, belowF, belowS int) {
			if idx == len(groups) {
				outcomes[[2]int{belowF + 1, belowS + 1}] = true
				return
			}
			for _, w := range groups[idx] {
				bf, bs := belowF, belowS
				if w < f {
					bf++
				}
				if w < s {
					bs++
				}
				rec(idx+1, bf, bs)
			}
		}
		rec(0, 0, 0)
		earliest, latest := INF, -INF
		for oc := range outcomes {
			r := dp(newM, oc[0], oc[1])
			if r[0]+1 < earliest {
				earliest = r[0] + 1
			}
			if r[1]+1 > latest {
				latest = r[1] + 1
			}
		}
		res := [2]int{earliest, latest}
		memo[key] = res
		return res
	}
	r := dp(n, firstPlayer, secondPlayer)
	return []int{r[0], r[1]}
}
