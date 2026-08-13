func largestMagicSquare(grid [][]int) int {
	m := len(grid)
	if m == 0 {
		return 0
	}
	n := len(grid[0])
	maxK := m
	if n < maxK {
		maxK = n
	}
	for k := maxK; k >= 1; k-- {
		for i := 0; i+k <= m; i++ {
			for j := 0; j+k <= n; j++ {
				if isMagicSquare(grid, i, j, k) {
					return k
				}
			}
		}
	}
	return 1
}

func isMagicSquare(grid [][]int, r, c, k int) bool {
	target := 0
	for j := 0; j < k; j++ {
		target += grid[r][c+j]
	}
	for i := 0; i < k; i++ {
		s := 0
		for j := 0; j < k; j++ {
			s += grid[r+i][c+j]
		}
		if s != target {
			return false
		}
	}
	for j := 0; j < k; j++ {
		s := 0
		for i := 0; i < k; i++ {
			s += grid[r+i][c+j]
		}
		if s != target {
			return false
		}
	}
	d1, d2 := 0, 0
	for i := 0; i < k; i++ {
		d1 += grid[r+i][c+i]
		d2 += grid[r+i][c+k-1-i]
	}
	return d1 == target && d2 == target
}
