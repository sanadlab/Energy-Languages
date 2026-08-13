/**
 * @param {number[]} nums - The input array of integers.
 * @param {number} key - The target value to find in the array.
 * @param {number} k - The maximum allowed distance from an index to a key index.
 * @return {number[]} - A list of all k-distant indices sorted in increasing order.
 */
var findKDistantIndices = function(nums, key, k) {
    const n = nums.length;
    const result = [];
    let next = 0; // lowest index not yet emitted (dedupes overlapping windows)

    for (let i = 0; i < n; ++i) {
        if (nums[i] === key) {
            const hi = Math.min(i + k, n - 1);
            for (let j = Math.max(Math.max(i - k, 0), next); j <= hi; ++j) {
                result.push(j);
            }
            next = Math.max(next, hi + 1);
        }
    }

    return result;
};