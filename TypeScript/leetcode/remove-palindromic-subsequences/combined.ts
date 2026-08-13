function removePalindromeSub(s: string): number {
    if (s.length === 0) return 0;
    let l = 0, r = s.length - 1;
    while (l < r) {
        if (s[l] !== s[r]) return 2;
        l++; r--;
    }
    return 1;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().removePalindromeSub("abcde")'); }
catch (_e) { _lc_test_result = eval('removePalindromeSub("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
