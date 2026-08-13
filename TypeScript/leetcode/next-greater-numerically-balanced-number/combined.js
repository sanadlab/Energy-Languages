"use strict";
function nextBeautifulNumber(n) {
    for (let x = n + 1;; x++) {
        const cnt = new Array(10).fill(0);
        let t = x;
        while (t > 0) {
            cnt[t % 10]++;
            t = Math.floor(t / 10);
        }
        let ok = true;
        for (let d = 0; d < 10; d++) {
            if (cnt[d] !== 0 && cnt[d] !== d) {
                ok = false;
                break;
            }
        }
        if (ok)
            return x;
    }
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().nextBeautifulNumber(20)');
}
catch (_e) {
    _lc_test_result = eval('nextBeautifulNumber(20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
