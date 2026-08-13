"use strict";
function numOfWays(nums) {
    const MOD = 1000000007n;
    const n = nums.length;
    const C = [];
    for (let i = 0; i <= n; i++) {
        C.push(new Array(n + 1).fill(0n));
        C[i][0] = 1n;
        for (let j = 1; j <= i; j++)
            C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD;
    }
    const ways = (arr) => {
        const m = arr.length;
        if (m <= 2)
            return 1n;
        const root = arr[0];
        const left = [], right = [];
        for (let i = 1; i < m; i++) {
            if (arr[i] < root)
                left.push(arr[i]);
            else
                right.push(arr[i]);
        }
        return C[m - 1][left.length] * ways(left) % MOD * ways(right) % MOD;
    };
    return Number((ways(nums) - 1n + MOD) % MOD);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().numOfWays([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('numOfWays([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
