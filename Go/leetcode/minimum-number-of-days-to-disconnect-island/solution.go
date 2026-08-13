func minDays(grid [][]int) int {
    rows := len(grid)
    cols := len(grid[0])
    var dfs func(visited [][]bool, i, j int)
    dfs = func(visited [][]bool, i, j int) {
        if i < 0 || i >= rows || j < 0 || j >= cols || grid[i][j] != 1 || visited[i][j] {
            return
        }
        visited[i][j] = true
        dfs(visited, i+1, j)
        dfs(visited, i-1, j)
        dfs(visited, i, j+1)
        dfs(visited, i, j-1)
    }
    countIslands := func() int {
        visited := make([][]bool, rows)
        for i := range visited {
            visited[i] = make([]bool, cols)
        }
        count := 0
        for i := 0; i < rows; i++ {
            for j := 0; j < cols; j++ {
                if grid[i][j] == 1 && !visited[i][j] {
                    count++
                    dfs(visited, i, j)
                }
            }
        }
        return count
    }
    if countIslands() != 1 {
        return 0
    }
    for i := 0; i < rows; i++ {
        for j := 0; j < cols; j++ {
            if grid[i][j] == 1 {
                grid[i][j] = 0
                if countIslands() != 1 {
                    grid[i][j] = 1
                    return 1
                }
                grid[i][j] = 1
            }
        }
    }
    return 2
}
