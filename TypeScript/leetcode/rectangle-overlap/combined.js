"use strict";
function isRectangleOverlap(rec1, rec2) {
    return rec1[0] < rec2[2] && rec2[0] < rec1[2] &&
        rec1[1] < rec2[3] && rec2[1] < rec1[3];
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().isRectangleOverlap([1,2,3,4,5], [1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('isRectangleOverlap([1,2,3,4,5], [1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
