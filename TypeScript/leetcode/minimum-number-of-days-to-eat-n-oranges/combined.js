"use strict";
function minDays(n) {
    const memo = new Map();
    function solve(oranges) {
        if (oranges <= 1)
            return oranges;
        const cached = memo.get(oranges);
        if (cached !== undefined)
            return cached;
        const days = 1 + Math.min(oranges % 2 + solve(Math.floor(oranges / 2)), oranges % 3 + solve(Math.floor(oranges / 3)));
        memo.set(oranges, days);
        return days;
    }
    return solve(n);
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minDays(20)');
}
catch (_e) {
    _lc_test_result = eval('minDays(20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
