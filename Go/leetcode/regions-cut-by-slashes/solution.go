func regionsBySlashes(grid []string) int {
    n := len(grid)
    parent := make([]int, 4*n*n)
    for i := range parent {
        parent[i] = i
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
        if ra != rb {
            parent[ra] = rb
        }
    }
    for r := 0; r < n; r++ {
        for c := 0; c < n; c++ {
            base := 4 * (r*n + c)
            top, right, bottom, left := base, base+1, base+2, base+3
            var ch byte = ' '
            if c < len(grid[r]) {
                ch = grid[r][c]
            }
            if ch == '/' {
                union(top, left)
                union(right, bottom)
            } else if ch == '\\' {
                union(top, right)
                union(left, bottom)
            } else {
                union(top, right)
                union(right, bottom)
                union(bottom, left)
            }
            if c+1 < n {
                union(right, 4*(r*n+c+1)+3)
            }
            if r+1 < n {
                union(bottom, 4*((r+1)*n+c))
            }
        }
    }
    cnt := 0
    for i := 0; i < 4*n*n; i++ {
        if find(i) == i {
            cnt++
        }
    }
    return cnt
}
