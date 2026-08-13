function minDays(n: number): number {
    const memo = new Map<number, number>();
    const solve = (x: number): number => {
        if (x <= 1) return x;
        if (memo.has(x)) return memo.get(x)!;
        const res = 1 + Math.min(x % 2 + solve(Math.floor(x / 2)), x % 3 + solve(Math.floor(x / 3)));
        memo.set(x, res);
        return res;
    };
    return solve(n);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().minDays(20)'); }
catch (_e) { _lc_test_result = eval('minDays(20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
