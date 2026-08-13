function countVowelPermutation(n: number): number {
    const MOD = 1000000007;
    let a = 1, e = 1, i = 1, o = 1, u = 1;
    for (let k = 1; k < n; k++) {
        const na = (e + i + u) % MOD;
        const ne = (a + i) % MOD;
        const ni = (e + o) % MOD;
        const no = i % MOD;
        const nu = (i + o) % MOD;
        a = na; e = ne; i = ni; o = no; u = nu;
    }
    return (a + e + i + o + u) % MOD;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().countVowelPermutation(20)'); }
catch (_e) { _lc_test_result = eval('countVowelPermutation(20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
