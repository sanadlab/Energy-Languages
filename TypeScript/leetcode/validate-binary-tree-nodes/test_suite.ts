// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().validateBinaryTreeNodes(20, [1,2,3,4,5], [1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('validateBinaryTreeNodes(20, [1,2,3,4,5], [1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
