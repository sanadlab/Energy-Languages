"use strict";
function maxCompatibilitySum(students, mentors) {
    const m = students.length;
    const n = m > 0 ? students[0].length : 0;
    const score = Array.from({ length: m }, () => new Array(m).fill(0));
    for (let i = 0; i < m; i++)
        for (let j = 0; j < m; j++)
            for (let k = 0; k < n; k++)
                if (students[i][k] === mentors[j][k])
                    score[i][j]++;
    const dp = new Array(1 << m).fill(0);
    for (let mask = 0; mask < (1 << m); mask++) {
        let cnt = 0;
        for (let x = mask; x > 0; x >>= 1)
            cnt += x & 1;
        if (cnt >= m)
            continue;
        for (let j = 0; j < m; j++) {
            if ((mask >> j) & 1)
                continue;
            const nm = mask | (1 << j);
            const val = dp[mask] + score[cnt][j];
            if (val > dp[nm])
                dp[nm] = val;
        }
    }
    return dp[(1 << m) - 1];
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().maxCompatibilitySum([[1,2],[3,4]], [[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('maxCompatibilitySum([[1,2],[3,4]], [[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
