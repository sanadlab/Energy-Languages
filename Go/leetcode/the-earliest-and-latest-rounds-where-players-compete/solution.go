func earliestAndLatest(n int, firstPlayer int, secondPlayer int) []int {
	if firstPlayer == secondPlayer {
		return []int{1, 1}
	}
	if firstPlayer > secondPlayer {
		firstPlayer, secondPlayer = secondPlayer, firstPlayer
	}
	const INF = 1 << 30
	memo := map[int][2]int{}
	var dp func(n, f, s int) [2]int
	dp = func(n, f, s int) [2]int {
		if f+s == n+1 {
			return [2]int{1, 1}
		}
		if f+s > n+1 {
			f, s = n+1-s, n+1-f
		}
		key := (n*100+f)*100 + s
		if v, ok := memo[key]; ok {
			return v
		}
		half := (n + 1) / 2
		earliest, latest := INF, -INF
		if s <= half {
			for i := 0; i < f; i++ {
				for j := 0; j < s-f; j++ {
					r := dp(half, i+1, i+j+2)
					if r[0] < earliest {
						earliest = r[0]
					}
					if r[1] > latest {
						latest = r[1]
					}
				}
			}
		} else {
			sp := n + 1 - s
			mid := n / 2
			for i := 0; i < f; i++ {
				for j := 0; j < sp-f; j++ {
					r := dp(half, i+1, i+(mid-sp)+j+2)
					if r[0] < earliest {
						earliest = r[0]
					}
					if r[1] > latest {
						latest = r[1]
					}
				}
			}
		}
		res := [2]int{earliest + 1, latest + 1}
		memo[key] = res
		return res
	}
	r := dp(n, firstPlayer, secondPlayer)
	return []int{r[0], r[1]}
}
