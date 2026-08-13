"use strict";
function areOccurrencesEqual(s) {
    const cnt = {};
    for (const c of s)
        cnt[c] = (cnt[c] || 0) + 1;
    const vals = Object.values(cnt);
    return vals.every(v => v === vals[0]);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().areOccurrencesEqual("abcde")');
}
catch (_e) {
    _lc_test_result = eval('areOccurrencesEqual("abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
