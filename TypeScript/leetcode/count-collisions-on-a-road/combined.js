"use strict";
function countCollisions(directions) {
    const n = directions.length;
    let i = 0;
    while (i < n && directions[i] === 'L')
        i++;
    let j = n - 1;
    while (j >= 0 && directions[j] === 'R')
        j--;
    let count = 0;
    for (let k = i; k <= j; k++) {
        if (directions[k] !== 'S')
            count++;
    }
    return count;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().countCollisions("abcde")');
}
catch (_e) {
    _lc_test_result = eval('countCollisions("abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
