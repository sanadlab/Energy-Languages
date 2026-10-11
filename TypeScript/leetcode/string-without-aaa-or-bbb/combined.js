"use strict";
function strWithout3a3b(a, b) {
    const result = [];
    while (a > 0 || b > 0) {
        const n = result.length;
        let useA = a >= b;
        if (n >= 2 && result[n - 1] === result[n - 2]) {
            useA = result[n - 1] === "b";
        }
        if (useA) {
            result.push("a");
            a--;
        }
        else {
            result.push("b");
            b--;
        }
    }
    return result.join("");
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().strWithout3a3b(20, 20)');
}
catch (_e) {
    _lc_test_result = eval('strWithout3a3b(20, 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
