"use strict";
function countVowelPermutation(n) {
    const MOD = 1000000007;
    let a = 1, e = 1, i = 1, o = 1, u = 1;
    for (let length = 2; length <= n; length++) {
        const nextA = (e + i + u) % MOD;
        const nextE = (a + i) % MOD;
        const nextI = (e + o) % MOD;
        const nextO = i;
        const nextU = (i + o) % MOD;
        a = nextA;
        e = nextE;
        i = nextI;
        o = nextO;
        u = nextU;
    }
    return (a + e + i + o + u) % MOD;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().countVowelPermutation(20)');
}
catch (_e) {
    _lc_test_result = eval('countVowelPermutation(20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
