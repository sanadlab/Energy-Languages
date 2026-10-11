function maxSizeSlices(slices) {
    const m = slices.length;
    const n = m / 3;
    const helper = (arr, k) => {
        const len = arr.length;
        const dp = Array.from({ length: len + 1 }, () => new Array(k + 1).fill(Number.NEGATIVE_INFINITY));
        for (let i = 0; i <= len; i++) {
            dp[i][0] = 0;
        }
        for (let i = 1; i <= len; i++) {
            for (let j = 1; j <= k; j++) {
                dp[i][j] = dp[i - 1][j];
                const prev = i >= 2 ? dp[i - 2][j - 1] : (j === 1 ? 0 : Number.NEGATIVE_INFINITY);
                dp[i][j] = Math.max(dp[i][j], prev + arr[i - 1]);
            }
        }
        return dp[len][k];
    };
    return Math.max(helper(slices.slice(0, m - 1), n), helper(slices.slice(1), n));
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().maxSizeSlices([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('maxSizeSlices([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
