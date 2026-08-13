"use strict";
class Solution {
    isMatch(s, p) {
        const m = s.length;
        const n = p.length;
        const dp = new Array(m + 1).fill(null).map(() => new Array(n + 1).fill(false));
        dp[0][0] = true;
        for (let j = 1; j <= n; j++) {
            if (p.charAt(j - 1) === '*') {
                dp[0][j] = dp[0][j - 1];
            }
            else {
                dp[0][j] = false;
            }
        }
        for (let i = 1; i <= m; i++) {
            dp[i][0] = false;
        }
        for (let i = 1; i <= m; i++) {
            for (let j = 1; j <= n; j++) {
                if (p.charAt(j - 1) === '*') {
                    dp[i][j] = dp[i][j - 1] || dp[i - 1][j];
                }
                else {
                    if (p.charAt(j - 1) === '?' || s.charAt(i - 1) === p.charAt(j - 1)) {
                        dp[i][j] = dp[i - 1][j - 1];
                    }
                    else {
                        dp[i][j] = false;
                    }
                }
            }
        }
        return dp[m][n];
    }
} // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().isMatch("abcde", "abcde")');
}
catch (_e) {
    _lc_test_result = eval('isMatch("abcde", "abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
