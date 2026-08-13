function shiftGrid(grid: number[][], k: number): number[][] {
    const m = grid.length;
    const n = m > 0 ? grid[0].length : 0;
    const total = m * n;
    if (total === 0) return grid;
    k %= total;
    const flat: number[] = [];
    for (let i = 0; i < m; i++) for (let j = 0; j < n; j++) flat.push(grid[i][j]);
    const res: number[][] = Array.from({length: m}, () => new Array(n).fill(0));
    for (let idx = 0; idx < total; idx++) {
        const np = (idx + k) % total;
        res[Math.floor(np / n)][np % n] = flat[idx];
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().shiftGrid([[1,2],[3,4]], 20)'); }
catch (_e) { _lc_test_result = eval('shiftGrid([[1,2],[3,4]], 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
