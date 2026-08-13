package main

func hitBricks(grid [][]int, hits [][]int) []int {
	m := len(grid)
	n := 0
	if m > 0 {
		n = len(grid[0])
	}
	total := m * n
	top := total
	parent := make([]int, total+1)
	sz := make([]int, total+1)
	for i := range parent {
		parent[i] = i
		sz[i] = 1
	}

	var find func(int) int
	find = func(x int) int {
		for parent[x] != x {
			parent[x] = parent[parent[x]]
			x = parent[x]
		}
		return x
	}
	union := func(a, b int) {
		ra, rb := find(a), find(b)
		if ra == rb {
			return
		}
		if sz[ra] < sz[rb] {
			ra, rb = rb, ra
		}
		parent[rb] = ra
		sz[ra] += sz[rb]
	}
	inb := func(r, c int) bool { return r >= 0 && r < m && c >= 0 && c < n }

	g := make([][]int, m)
	for r := 0; r < m; r++ {
		g[r] = make([]int, n)
		for c := 0; c < n && c < len(grid[r]); c++ {
			if grid[r][c] == 1 {
				g[r][c] = 1
			}
		}
	}

	for _, h := range hits {
		if len(h) < 2 {
			continue
		}
		r, c := h[0], h[1]
		if inb(r, c) {
			g[r][c] = 0
		}
	}

	for r := 0; r < m; r++ {
		for c := 0; c < n; c++ {
			if g[r][c] == 1 {
				cur := r*n + c
				if r == 0 {
					union(cur, top)
				}
				if r > 0 && g[r-1][c] == 1 {
					union(cur, (r-1)*n+c)
				}
				if c > 0 && g[r][c-1] == 1 {
					union(cur, r*n+c-1)
				}
			}
		}
	}

	dirs := [4][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
	res := make([]int, len(hits))
	for i := len(hits) - 1; i >= 0; i-- {
		if len(hits[i]) < 2 {
			continue
		}
		r, c := hits[i][0], hits[i][1]
		if !inb(r, c) {
			continue
		}
		if grid[r][c] != 1 {
			continue
		}
		before := sz[find(top)]
		g[r][c] = 1
		cur := r*n + c
		if r == 0 {
			union(cur, top)
		}
		for _, d := range dirs {
			nr, nc := r+d[0], c+d[1]
			if inb(nr, nc) && g[nr][nc] == 1 {
				union(cur, nr*n+nc)
			}
		}
		after := sz[find(top)]
		f := after - before - 1
		if f < 0 {
			f = 0
		}
		res[i] = f
	}
	return res
}
