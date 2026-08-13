"use strict";
function diStringMatch(s) {
    const n = s.length;
    let lo = 0, hi = n;
    const res = [];
    for (let i = 0; i < n; i++) {
        if (s[i] === 'I')
            res.push(lo++);
        else
            res.push(hi--);
    }
    res.push(lo);
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().diStringMatch("abcde")');
}
catch (_e) {
    _lc_test_result = eval('diStringMatch("abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
