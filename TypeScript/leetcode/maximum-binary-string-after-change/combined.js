"use strict";
function maximumBinaryString(binary) {
    const n = binary.length;
    let first = -1, zeros = 0;
    for (let i = 0; i < n; i++) {
        if (binary[i] === '0') {
            if (first === -1)
                first = i;
            zeros++;
        }
    }
    if (first === -1)
        return binary;
    const res = new Array(n).fill('1');
    res[first + zeros - 1] = '0';
    return res.join('');
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().maximumBinaryString("abcde")');
}
catch (_e) {
    _lc_test_result = eval('maximumBinaryString("abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
