"use strict";
function splitArray(nums, k) {
    let lo = 0, hi = 0;
    for (const x of nums) {
        lo = Math.max(lo, x);
        hi += x;
    }
    while (lo < hi) {
        const mid = Math.floor(lo + (hi - lo) / 2);
        let cnt = 1, cur = 0;
        for (const x of nums) {
            if (cur + x > mid) {
                cnt++;
                cur = x;
            }
            else
                cur += x;
        }
        if (cnt <= k)
            hi = mid;
        else
            lo = mid + 1;
    }
    return lo;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().splitArray([1,2,3,4,5], 20)');
}
catch (_e) {
    _lc_test_result = eval('splitArray([1,2,3,4,5], 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
