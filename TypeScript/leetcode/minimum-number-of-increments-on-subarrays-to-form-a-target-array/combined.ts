function minNumberOperations(target: number[]): number {
    if (target.length === 0) return 0;
    let ans = target[0];
    for (let i = 1; i < target.length; i++) {
        if (target[i] > target[i-1]) ans += target[i] - target[i-1];
    }
    return ans;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().minNumberOperations([1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('minNumberOperations([1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
