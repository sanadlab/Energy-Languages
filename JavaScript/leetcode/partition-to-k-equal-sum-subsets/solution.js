/**
 * @param {number[]} nums
 * @param {number} k
 * @return {boolean}
 */
var canPartitionKSubsets = function(nums, k) {
    if (k <= 0 || nums.length < k) return false;
    const sum = nums.reduce((a, b) => a + b, 0);
    if (sum % k !== 0) return false;
    const target = sum / k;
    nums.sort((a, b) => b - a);
    if (nums[0] > target) return false;
    const used = new Array(nums.length).fill(false);
    const backtrack = (k, cur, start) => {
        if (k === 0) return true;
        if (cur === target) return backtrack(k - 1, 0, 0);
        for (let i = start; i < nums.length; i++) {
            if (used[i] || cur + nums[i] > target) continue;
            used[i] = true;
            if (backtrack(k, cur + nums[i], i + 1)) return true;
            used[i] = false;
            if (cur === 0) break;
        }
        return false;
    };
    return backtrack(k, 0, 0);
};
