function countCollisions(directions: string): number {
    let left = 0;
    let right = directions.length - 1;

    while (left <= right && directions[left] === 'L') {
        left++;
    }

    while (left <= right && directions[right] === 'R') {
        right--;
    }

    let collisions = 0;
    for (let i = left; i <= right; i++) {
        if (directions[i] !== 'S') {
            collisions++;
        }
    }

    return collisions;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().countCollisions("abcde")'); }
catch (_e) { _lc_test_result = eval('countCollisions("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
