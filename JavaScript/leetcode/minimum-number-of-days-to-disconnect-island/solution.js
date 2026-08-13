var minDays = function(grid) {
    const rows = grid.length, cols = grid[0].length;
    const dfs = (visited, i, j) => {
        if (i < 0 || i >= rows || j < 0 || j >= cols || grid[i][j] !== 1 || visited[i][j]) return;
        visited[i][j] = true;
        dfs(visited, i+1, j);
        dfs(visited, i-1, j);
        dfs(visited, i, j+1);
        dfs(visited, i, j-1);
    };
    const countIslands = () => {
        const visited = Array.from({length: rows}, () => new Array(cols).fill(false));
        let count = 0;
        for (let i = 0; i < rows; i++)
            for (let j = 0; j < cols; j++)
                if (grid[i][j] === 1 && !visited[i][j]) {
                    count++;
                    dfs(visited, i, j);
                }
        return count;
    };
    if (countIslands() !== 1) return 0;
    for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
            if (grid[i][j] === 1) {
                grid[i][j] = 0;
                if (countIslands() !== 1) { grid[i][j] = 1; return 1; }
                grid[i][j] = 1;
            }
        }
    }
    return 2;
};
