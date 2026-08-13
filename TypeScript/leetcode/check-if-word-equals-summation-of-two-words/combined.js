"use strict";
function isSumEqual(firstWord, secondWord, targetWord) {
    const val = (s) => {
        let n = 0;
        for (const c of s)
            n = n * 10 + (c.charCodeAt(0) - 97);
        return n;
    };
    return val(firstWord) + val(secondWord) === val(targetWord);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().isSumEqual("abcde", "abcde", "abcde")');
}
catch (_e) {
    _lc_test_result = eval('isSumEqual("abcde", "abcde", "abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
