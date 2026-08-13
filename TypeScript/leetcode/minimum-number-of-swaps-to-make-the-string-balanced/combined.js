"use strict";
function minSwaps(s) {
    let open = 0;
    for (const c of s) {
        if (c === '[')
            open++;
        else if (open > 0)
            open--;
    }
    return Math.floor((open + 1) / 2);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minSwaps("abcde")');
}
catch (_e) {
    _lc_test_result = eval('minSwaps("abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
