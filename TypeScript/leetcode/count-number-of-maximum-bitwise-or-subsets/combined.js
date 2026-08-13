"use strict";
class Solution {
    countMaxOrSubsets(nums) {
        const n = nums.length;
        const maxOr = nums.reduce((acc, num) => acc | num, 0);
        let count = 0;
        for (let mask = 1; mask < (1 << n); mask++) {
            let currentOr = 0;
            for (let i = 0; i < n; i++) {
                if (mask & (1 << i)) {
                    currentOr |= nums[i];
                }
            }
            if (currentOr === maxOr) {
                count++;
            }
        }
        return count;
    }
} // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().countMaxOrSubsets([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('countMaxOrSubsets([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
