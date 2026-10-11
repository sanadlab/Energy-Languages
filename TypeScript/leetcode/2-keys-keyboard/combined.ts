function minSteps(n: number): number {
    let operations = 0;

    for (let factor = 2; factor * factor <= n; factor++) {
        while (n % factor === 0) {
            operations += factor;
            n /= factor;
        }
    }

    if (n > 1) {
        operations += n;
    }

    return operations;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().minSteps(20)'); }
catch (_e) { _lc_test_result = eval('minSteps(20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
