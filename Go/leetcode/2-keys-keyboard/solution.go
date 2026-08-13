func minSteps(n int) int {
	res := 0
	for d := 2; d <= n; d++ {
		for n%d == 0 {
			res += d
			n /= d
		}
	}
	return res
}
