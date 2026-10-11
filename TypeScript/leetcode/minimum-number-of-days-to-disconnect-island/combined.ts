function minDays(grid: number[][]): number {
    const rows = grid.length;
    const cols = grid[0].length;
    const visited = new Uint8Array(rows * cols);
    const directions = [-1, 0, 1, 0, -1];

    function countIslands(): number {
        visited.fill(0);
        let islands = 0;

        for (let r = 0; r < rows; r++) {
            for (let c = 0; c < cols; c++) {
                const id = r * cols + c;
                if (grid[r][c] === 0 || visited[id]) continue;

                if (++islands > 1) return islands;

                const stack: number[] = [id];
                visited[id] = 1;

                while (stack.length > 0) {
                    const current = stack.pop()!;
                    const cr = Math.floor(current / cols);
                    const cc = current % cols;

                    for (let d = 0; d < 4; d++) {
                        const nr = cr + directions[d];
                        const nc = cc + directions[d + 1];

                        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) {
                            continue;
                        }

                        const nextId = nr * cols + nc;
                        if (grid[nr][nc] === 1 && !visited[nextId]) {
                            visited[nextId] = 1;
                            stack.push(nextId);
                        }
                    }
                }
            }
        }

        return islands;
    }

    if (countIslands() !== 1) return 0;

    for (let r = 0; r < rows; r++) {
        for (let c = 0; c < cols; c++) {
            if (grid[r][c] === 0) continue;

            grid[r][c] = 0;
            const disconnected = countIslands() !== 1;
            grid[r][c] = 1;

            if (disconnected) return 1;
        }
    }

    return 2;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().minDays([[1,2],[3,4]])'); }
catch (_e) { _lc_test_result = eval('minDays([[1,2],[3,4]])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
