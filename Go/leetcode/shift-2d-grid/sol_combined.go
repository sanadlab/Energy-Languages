package main

func shiftGrid(grid [][]int, k int) [][]int {
    m, n := len(grid), len(grid[0])
    total := m * n
    k = k % total
    if k == 0 {
        return grid
    }

    res := make([][]int, m)
    for i := range res {
        res[i] = make([]int, n)
    }

    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            pos := i*n + j
            newPos := (pos + k) % total
            newRow := newPos / n
            newCol := newPos % n
            res[newRow][newCol] = grid[i][j]
        }
    }
    return res
}
