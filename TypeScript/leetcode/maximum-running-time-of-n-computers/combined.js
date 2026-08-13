"use strict";
function maxRunTime(n, batteries) {
    let sum = 0n;
    for (const b of batteries)
        sum += BigInt(b);
    const N = BigInt(n);
    let lo = 0n, hi = sum / N;
    while (lo < hi) {
        const mid = (lo + hi + 1n) / 2n;
        let avail = 0n;
        for (const b of batteries) {
            const bb = BigInt(b);
            avail += bb < mid ? bb : mid;
        }
        if (avail >= N * mid)
            lo = mid;
        else
            hi = mid - 1n;
    }
    return Number(lo);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().maxRunTime(20, [1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('maxRunTime(20, [1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
