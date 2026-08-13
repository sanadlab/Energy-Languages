func countCollisions(directions string) int {
	n := len(directions)
	i := 0
	for i < n && directions[i] == 'L' {
		i++
	}
	j := n - 1
	for j >= 0 && directions[j] == 'R' {
		j--
	}
	count := 0
	for k := i; k <= j; k++ {
		if directions[k] != 'S' {
			count++
		}
	}
	return count
}
