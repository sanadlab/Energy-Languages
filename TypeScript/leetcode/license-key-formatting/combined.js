"use strict";
class Solution {
    licenseKeyFormatting(s, k) {
        const cleaned = s.replace(/-/g, '').toUpperCase();
        const t = cleaned;
        const L = t.length;
        if (L === 0)
            return '';
        const m = L % k;
        const firstGroup = t.slice(0, m === 0 ? k : m);
        const rest = t.slice(m === 0 ? k : m);
        const groups = [];
        for (let i = 0; i < rest.length; i += k) {
            groups.push(rest.slice(i, i + k));
        }
        return firstGroup + groups.join('-');
    }
} // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().licenseKeyFormatting("abcde", 20)');
}
catch (_e) {
    _lc_test_result = eval('licenseKeyFormatting("abcde", 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
