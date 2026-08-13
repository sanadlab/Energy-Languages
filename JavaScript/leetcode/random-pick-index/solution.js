/**
 * @param {number[]} nums
 */
var Solution = function(nums) {
    this.nums = nums || [];
};

/**
 * Harness-compat initializer (the generated test suite calls
 * `new Solution().Solution([...])`). Real callers use `new Solution(nums)`.
 * @param {number[]} nums
 */
Solution.prototype.Solution = function(nums) {
    this.nums = nums || [];
    return this;
};

/**
 * @param {number} target
 * @return {number}
 */
Solution.prototype.pick = function(target) {
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
};
