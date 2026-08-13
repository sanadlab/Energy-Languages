"use strict";
function clumsy(n) {
    const stack = [n];
    let op = 0;
    for (let x = n - 1; x >= 1; x--) {
        if (op === 0)
            stack[stack.length - 1] *= x;
        else if (op === 1)
            stack[stack.length - 1] = Math.trunc(stack[stack.length - 1] / x);
        else if (op === 2)
            stack.push(x);
        else
            stack.push(-x);
        op = (op + 1) % 4;
    }
    return stack.reduce((a, b) => a + b, 0);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().clumsy(20)');
}
catch (_e) {
    _lc_test_result = eval('clumsy(20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
