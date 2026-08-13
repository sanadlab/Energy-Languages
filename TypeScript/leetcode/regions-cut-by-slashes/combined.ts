function regionsBySlashes(grid: string[]): number {
    const n = grid.length;
    const parent: number[] = Array.from({length: 4 * n * n}, (_, i) => i);
    const find = (x: number): number => { while (parent[x] !== x) { parent[x] = parent[parent[x]]; x = parent[x]; } return x; };
    const union = (a: number, b: number): void => { const ra = find(a), rb = find(b); if (ra !== rb) parent[ra] = rb; };
    for (let r = 0; r < n; r++) {
        for (let c = 0; c < n; c++) {
            const base = 4 * (r * n + c);
            const top = base, right = base + 1, bottom = base + 2, left = base + 3;
            const ch = c < grid[r].length ? grid[r][c] : ' ';
            if (ch === '/') { union(top, left); union(right, bottom); }
            else if (ch === '\\') { union(top, right); union(left, bottom); }
            else { union(top, right); union(right, bottom); union(bottom, left); }
            if (c + 1 < n) union(right, 4 * (r * n + c + 1) + 3);
            if (r + 1 < n) union(bottom, 4 * ((r + 1) * n + c));
        }
    }
    let cnt = 0;
    for (let i = 0; i < 4 * n * n; i++) if (find(i) === i) cnt++;
    return cnt;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().regionsBySlashes(["a","b","c"])'); }
catch (_e) { _lc_test_result = eval('regionsBySlashes(["a","b","c"])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
