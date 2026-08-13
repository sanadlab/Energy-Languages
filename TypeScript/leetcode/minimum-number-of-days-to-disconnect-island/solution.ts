function minDays(grid: number[][]): number {
    const rows = grid.length, cols = grid[0].length;
    const countIslands = (): number => {
        const visited: boolean[][] = Array.from({length: rows}, () => new Array(cols).fill(false));
        let count = 0;
        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                if (grid[i][j] === 1 && !visited[i][j]) {
                    count++;
                    const stack: [number, number][] = [[i, j]];
                    visited[i][j] = true;
                    while (stack.length) {
                        const cur = stack.pop() as [number, number];
                        const x = cur[0], y = cur[1];
                        const dirs: [number, number][] = [[1, 0], [-1, 0], [0, 1], [0, -1]];
                        for (const d of dirs) {
                            const nx = x + d[0], ny = y + d[1];
                            if (nx >= 0 && nx < rows && ny >= 0 && ny < cols && grid[nx][ny] === 1 && !visited[nx][ny]) {
                                visited[nx][ny] = true;
                                stack.push([nx, ny]);
                            }
                        }
                    }
                }
            }
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
}
