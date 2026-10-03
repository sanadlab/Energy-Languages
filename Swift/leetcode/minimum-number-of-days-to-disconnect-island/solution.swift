class Solution {
    func minDays(_ grid: [[Int]]) -> Int {
        var grid = grid
        let rows = grid.count
        let cols = grid[0].count
        let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        func countIslands() -> Int {
            var visited = [[Bool]](repeating: [Bool](repeating: false, count: cols), count: rows)
            var count = 0
            for i in 0..<rows {
                for j in 0..<cols {
                    if grid[i][j] == 1 && !visited[i][j] {
                        count += 1
                        var stack = [(i, j)]
                        visited[i][j] = true
                        while let (x, y) = stack.popLast() {
                            for (dx, dy) in dirs {
                                let nx = x + dx, ny = y + dy
                                if nx >= 0 && nx < rows && ny >= 0 && ny < cols
                                    && grid[nx][ny] == 1 && !visited[nx][ny] {
                                    visited[nx][ny] = true
                                    stack.append((nx, ny))
                                }
                            }
                        }
                    }
                }
            }
            return count
        }
        if countIslands() != 1 {
            return 0
        }
        for i in 0..<rows {
            for j in 0..<cols {
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
}
