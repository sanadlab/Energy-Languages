function canCross(stones: number[]): boolean {
    const n = stones.length;
    const index = new Map<number, number>();
    for (let i = 0; i < n; i++) index.set(stones[i], i);
    const dp: Set<number>[] = Array.from({ length: n }, () => new Set<number>());
    dp[0].add(0);
    for (let i = 0; i < n; i++) {
        for (const k of dp[i]) {
            for (const step of [k - 1, k, k + 1]) {
                if (step > 0) {
                    const pos = stones[i] + step;
                    if (index.has(pos)) {
                        const j = index.get(pos)!;
                        if (j !== i) dp[j].add(step);
                    }
                }
            }
        }
    }
    return dp[n - 1].size > 0;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().canCross([1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('canCross([1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
