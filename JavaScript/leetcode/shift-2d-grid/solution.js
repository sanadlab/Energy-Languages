/**
 * @param {number[][]} grid
 * @param {number} k
 * @return {number[][]}
 */
var shiftGrid = function(grid, k) {
    const m = grid.length;
    const n = m > 0 ? grid[0].length : 0;
    const total = m * n;
    if (total === 0) return grid;
    k %= total;
    const flat = [];
    for (let i = 0; i < m; i++) for (let j = 0; j < n; j++) flat.push(grid[i][j]);
    const res = Array.from({length: m}, () => new Array(n).fill(0));
    for (let idx = 0; idx < total; idx++) {
        const np = (idx + k) % total;
        res[Math.floor(np / n)][np % n] = flat[idx];
    }
    return res;
};
