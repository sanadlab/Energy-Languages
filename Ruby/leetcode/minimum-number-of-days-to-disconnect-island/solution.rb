def min_days(grid)
    rows = grid.length
    cols = grid[0].length
    count_islands = lambda do
        visited = Array.new(rows) { Array.new(cols, false) }
        count = 0
        (0...rows).each do |i|
            (0...cols).each do |j|
                if grid[i][j] == 1 && !visited[i][j]
                    count += 1
                    stack = [[i, j]]
                    visited[i][j] = true
                    until stack.empty?
                        x, y = stack.pop
                        [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
                            nx = x + dx
                            ny = y + dy
                            if nx >= 0 && nx < rows && ny >= 0 && ny < cols && grid[nx][ny] == 1 && !visited[nx][ny]
                                visited[nx][ny] = true
                                stack.push([nx, ny])
                            end
                        end
                    end
                end
            end
        end
        count
    end
    return 0 if count_islands.call != 1
    (0...rows).each do |i|
        (0...cols).each do |j|
            if grid[i][j] == 1
                grid[i][j] = 0
                if count_islands.call != 1
                    grid[i][j] = 1
                    return 1
                end
                grid[i][j] = 1
            end
        end
    end
    2
end
