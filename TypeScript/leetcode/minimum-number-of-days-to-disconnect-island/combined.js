"use strict";
function minDays(grid) {
    const rows = grid.length, cols = grid[0].length;
    const countIslands = () => {
        const visited = Array.from({ length: rows }, () => new Array(cols).fill(false));
        let count = 0;
        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                if (grid[i][j] === 1 && !visited[i][j]) {
                    count++;
                    const stack = [[i, j]];
                    visited[i][j] = true;
                    while (stack.length) {
                        const cur = stack.pop();
                        const x = cur[0], y = cur[1];
                        const dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
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
    if (countIslands() !== 1)
        return 0;
    for (let i = 0; i < rows; i++) {
        for (let j = 0; j < cols; j++) {
            if (grid[i][j] === 1) {
                grid[i][j] = 0;
                if (countIslands() !== 1) {
                    grid[i][j] = 1;
                    return 1;
                }
                grid[i][j] = 1;
            }
        }
    }
    return 2;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minDays([[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('minDays([[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
