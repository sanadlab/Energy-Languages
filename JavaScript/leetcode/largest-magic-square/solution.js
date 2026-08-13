var largestMagicSquare = function(grid) {
    const m = grid.length;
    if (m === 0) return 0;
    const n = grid[0].length;
    const maxK = Math.min(m, n);
    const isMagic = (r, c, k) => {
        let target = 0;
        for (let j = 0; j < k; j++) target += grid[r][c + j];
        for (let i = 0; i < k; i++) {
            let s = 0;
            for (let j = 0; j < k; j++) s += grid[r + i][c + j];
            if (s !== target) return false;
        }
        for (let j = 0; j < k; j++) {
            let s = 0;
            for (let i = 0; i < k; i++) s += grid[r + i][c + j];
            if (s !== target) return false;
        }
        let d1 = 0, d2 = 0;
        for (let i = 0; i < k; i++) {
            d1 += grid[r + i][c + i];
            d2 += grid[r + i][c + k - 1 - i];
        }
        return d1 === target && d2 === target;
    };
    for (let k = maxK; k >= 1; k--) {
        for (let i = 0; i + k <= m; i++) {
            for (let j = 0; j + k <= n; j++) {
                if (isMagic(i, j, k)) return k;
            }
        }
    }
    return 1;
};
