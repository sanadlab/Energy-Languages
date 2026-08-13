"use strict";
function medianSlidingWindow(nums, k) {
    const res = [];
    const n = nums.length;
    for (let i = 0; i + k <= n; i++) {
        const w = nums.slice(i, i + k).sort((a, b) => a - b);
        let median;
        if (k % 2 === 1)
            median = w[(k - 1) / 2];
        else
            median = (w[k / 2 - 1] + w[k / 2]) / 2;
        res.push(median);
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().medianSlidingWindow([1,2,3,4,5], 20)');
}
catch (_e) {
    _lc_test_result = eval('medianSlidingWindow([1,2,3,4,5], 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
