"use strict";
function sumOddLengthSubarrays(arr) {
    const n = arr.length;
    let total = 0;
    for (let i = 0; i < n; i++) {
        const count = Math.floor(((i + 1) * (n - i) + 1) / 2);
        total += count * arr[i];
    }
    return total;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().sumOddLengthSubarrays([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('sumOddLengthSubarrays([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
