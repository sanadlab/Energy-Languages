"use strict";
function canPartitionKSubsets(nums, k) {
    if (k <= 0 || nums.length < k)
        return false;
    const sum = nums.reduce((a, b) => a + b, 0);
    if (sum % k !== 0)
        return false;
    const target = sum / k;
    nums.sort((a, b) => b - a);
    if (nums[0] > target)
        return false;
    const used = new Array(nums.length).fill(false);
    const backtrack = (kk, cur, start) => {
        if (kk === 0)
            return true;
        if (cur === target)
            return backtrack(kk - 1, 0, 0);
        for (let i = start; i < nums.length; i++) {
            if (used[i] || cur + nums[i] > target)
                continue;
            used[i] = true;
            if (backtrack(kk, cur + nums[i], i + 1))
                return true;
            used[i] = false;
            if (cur === 0)
                break;
        }
        return false;
    };
    return backtrack(k, 0, 0);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().canPartitionKSubsets([1,2,3,4,5], 20)');
}
catch (_e) {
    _lc_test_result = eval('canPartitionKSubsets([1,2,3,4,5], 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
