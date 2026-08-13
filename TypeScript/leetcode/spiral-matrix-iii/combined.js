"use strict";
function spiralMatrixIII(rows, cols, rStart, cStart) {
    const total = rows * cols;
    const res = [];
    let r = rStart, c = cStart;
    if (r >= 0 && r < rows && c >= 0 && c < cols)
        res.push([r, c]);
    const dr = [0, 1, 0, -1];
    const dc = [1, 0, -1, 0];
    let step = 1, d = 0;
    while (res.length < total) {
        for (let t = 0; t < 2; t++) {
            for (let s = 0; s < step; s++) {
                r += dr[d % 4];
                c += dc[d % 4];
                if (r >= 0 && r < rows && c >= 0 && c < cols)
                    res.push([r, c]);
            }
            d++;
        }
        step++;
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().spiralMatrixIII(20, 20, 20, 20)');
}
catch (_e) {
    _lc_test_result = eval('spiralMatrixIII(20, 20, 20, 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
