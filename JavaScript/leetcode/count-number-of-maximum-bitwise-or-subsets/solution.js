/**
 * @param {number[]} nums
 * @return {number}
 */
var countMaxOrSubsets = function(nums) {
    let maxOr = 0;
    for (const v of nums) maxOr |= v;
    const n = nums.length;
    let count = 0;
    for (let mask = 1; mask < (1 << n); mask++) {
        let cur = 0;
        for (let i = 0; i < n; i++) {
            if (mask & (1 << i)) cur |= nums[i];
        }
        if (cur === maxOr) count++;
    }
    return count;
};
