"use strict";
function minAreaRect(points) {
    const seen = new Set();
    const n = points.length;
    const enc = (x, y) => x * 50000 + y;
    for (const p of points)
        seen.add(enc(p[0], p[1]));
    let best = Infinity;
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            const x1 = points[i][0], y1 = points[i][1];
            const x2 = points[j][0], y2 = points[j][1];
            if (x1 !== x2 && y1 !== y2) {
                if (seen.has(enc(x1, y2)) && seen.has(enc(x2, y1))) {
                    const area = Math.abs(x1 - x2) * Math.abs(y1 - y2);
                    best = Math.min(best, area);
                }
            }
        }
    }
    return best === Infinity ? 0 : best;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().minAreaRect([[1,2],[3,4]])');
}
catch (_e) {
    _lc_test_result = eval('minAreaRect([[1,2],[3,4]])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
