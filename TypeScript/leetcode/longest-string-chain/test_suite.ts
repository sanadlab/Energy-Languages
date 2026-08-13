// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().longestStrChain(["a","b","c"])'); }
catch (_e) { _lc_test_result = eval('longestStrChain(["a","b","c"])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
