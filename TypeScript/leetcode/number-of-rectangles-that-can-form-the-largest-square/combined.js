"use strict";
function countGoodRectangles(rectangles) {
    let maxLen = 0, count = 0;
    for (const r of rectangles) {
        const side = Math.min(r[0], r[1]);
        if (side > maxLen) {
            maxLen = side;
            count = 1;
        }
        else if (side === maxLen) {
            count++;
        }
    }
    return count;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().countGoodRectangles([[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('countGoodRectangles([[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
