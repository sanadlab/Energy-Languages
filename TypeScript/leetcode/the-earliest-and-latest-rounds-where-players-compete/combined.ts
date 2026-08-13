function earliestAndLatest(n: number, firstPlayer: number, secondPlayer: number): number[] {
    if (firstPlayer === secondPlayer) return [1, 1];
    let fp = firstPlayer, sp = secondPlayer;
    if (fp > sp) { const t = fp; fp = sp; sp = t; }
    const memo = new Map<number, [number, number]>();
    const INF = 1 << 30;
    function dp(n: number, f: number, s: number): [number, number] {
        if (f + s === n + 1) return [1, 1];
        if (f + s > n + 1) { const t = f; f = n + 1 - s; s = n + 1 - t; }
        const key = (n * 100 + f) * 100 + s;
        const cached = memo.get(key);
        if (cached) return cached;
        const half = Math.floor((n + 1) / 2);
        let earliest = INF, latest = -INF;
        if (s <= half) {
            for (let i = 0; i < f; i++)
                for (let j = 0; j < s - f; j++) {
                    const r = dp(half, i + 1, i + j + 2);
                    earliest = Math.min(earliest, r[0]);
                    latest = Math.max(latest, r[1]);
                }
        } else {
            const sp2 = n + 1 - s;
            const mid = Math.floor(n / 2);
            for (let i = 0; i < f; i++)
                for (let j = 0; j < sp2 - f; j++) {
                    const r = dp(half, i + 1, i + (mid - sp2) + j + 2);
                    earliest = Math.min(earliest, r[0]);
                    latest = Math.max(latest, r[1]);
                }
        }
        const res: [number, number] = [earliest + 1, latest + 1];
        memo.set(key, res);
        return res;
    }
    const r = dp(n, fp, sp);
    return [r[0], r[1]];
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().earliestAndLatest(20, 20, 20)'); }
catch (_e) { _lc_test_result = eval('earliestAndLatest(20, 20, 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
