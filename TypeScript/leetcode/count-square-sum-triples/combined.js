"use strict";
function countTriples(n) {
    let count = 0;
    for (let a = 1; a <= n; a++) {
        for (let b = 1; b <= n; b++) {
            const c2 = a * a + b * b;
            const c = Math.round(Math.sqrt(c2));
            if (c >= 1 && c <= n && c * c === c2)
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
    _lc_test_result = eval('new Solution().countTriples(20)');
}
catch (_e) {
    _lc_test_result = eval('countTriples(20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
