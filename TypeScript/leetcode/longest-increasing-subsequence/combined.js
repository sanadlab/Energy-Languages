"use strict";
function lengthOfLIS(nums) {
    const tails = [];
    for (const x of nums) {
        let lo = 0, hi = tails.length;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (tails[mid] < x)
                lo = mid + 1;
            else
                hi = mid;
        }
        tails[lo] = x;
    }
    return tails.length;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().lengthOfLIS([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('lengthOfLIS([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
