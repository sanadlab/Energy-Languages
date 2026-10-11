function shiftGrid(grid: number[][], k: number): number[][] {
    const m = grid.length;
    const n = grid[0].length;
    const total = m * n;
    k %= total;

    const result: number[][] = Array.from(
        { length: m },
        () => new Array<number>(n)
    );

    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            const destination = (i * n + j + k) % total;
            result[Math.floor(destination / n)][destination % n] = grid[i][j];
        }
    }

    return result;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().shiftGrid([[1,2],[3,4]], 20)'); }
catch (_e) { _lc_test_result = eval('shiftGrid([[1,2],[3,4]], 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
