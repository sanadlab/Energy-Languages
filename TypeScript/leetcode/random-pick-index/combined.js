"use strict";
class Solution {
    constructor(nums) {
        this.nums = nums;
    }
    pick(target) {
        // Reservoir sampling over indices whose value == target.
        let count = 0;
        let res = -1;
        for (let i = 0; i < this.nums.length; i++) {
            if (this.nums[i] === target) {
                count++;
                if (Math.floor(Math.random() * count) === 0) {
                    res = i;
                }
            }
        }
        return res;
    }
}
// LC-energy test suite (TypeScript) — hardcoded single case.
// Concatenated with solution.ts at compile time.
const _lc_obj = new Solution([1, 2, 3, 4, 5]);
const _lc_test_result = _lc_obj.pick(3);
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
