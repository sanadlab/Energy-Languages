function isMatch(s: string, p: string): boolean {
    const m = s.length, n = p.length;
    const dp: boolean[][] = Array.from({length: m + 1}, () => new Array(n + 1).fill(false));
    dp[m][n] = true;
    for (let i = m; i >= 0; i--) {
        for (let j = n - 1; j >= 0; j--) {
            const first = i < m && (p[j] === s[i] || p[j] === '.');
            if (j + 1 < n && p[j + 1] === '*') {
                dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j]);
            } else {
                dp[i][j] = first && dp[i + 1][j + 1];
            }
        }
    }
    return dp[0][0];
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().isMatch("abcde", "abcde")'); }
catch (_e) { _lc_test_result = eval('isMatch("abcde", "abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
