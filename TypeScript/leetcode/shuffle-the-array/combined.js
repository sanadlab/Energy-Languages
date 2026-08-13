"use strict";
function shuffle(nums, n) {
    const m = Math.floor(nums.length / 2);
    const res = [];
    for (let i = 0; i < m; i++) {
        res.push(nums[i], nums[i + m]);
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().shuffle([1,2,3,4,5], 20)');
}
catch (_e) {
    _lc_test_result = eval('shuffle([1,2,3,4,5], 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
