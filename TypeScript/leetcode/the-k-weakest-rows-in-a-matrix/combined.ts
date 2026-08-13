function kWeakestRows(mat: number[][], k: number): number[] {
    const rows: [number, number][] = mat.map((row, i) => [row.reduce((a, v) => a + (v === 1 ? 1 : 0), 0), i]);
    rows.sort((a, b) => a[0] - b[0] || a[1] - b[1]);
    return rows.slice(0, Math.min(k, rows.length)).map(r => r[1]);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().kWeakestRows([[1,2],[3,4]], 20)'); }
catch (_e) { _lc_test_result = eval('kWeakestRows([[1,2],[3,4]], 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
