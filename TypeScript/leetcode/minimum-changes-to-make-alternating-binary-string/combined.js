"use strict";
function minOperations(s) {
    let cnt = 0;
    const n = s.length;
    for (let i = 0; i < n; i++) {
        const expected = (i % 2 === 0) ? '0' : '1';
        if (s[i] !== expected)
            cnt++;
    }
    return Math.min(cnt, n - cnt);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minOperations("abcde")');
}
catch (_e) {
    _lc_test_result = eval('minOperations("abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
