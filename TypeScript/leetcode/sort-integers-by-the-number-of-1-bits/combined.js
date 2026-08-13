"use strict";
function sortByBits(arr) {
    const bits = (x) => { let c = 0; while (x > 0) {
        c += x & 1;
        x >>>= 1;
    } return c; };
    return arr.slice().sort((a, b) => bits(a) - bits(b) || a - b);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().sortByBits([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('sortByBits([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
