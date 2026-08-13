/**
 * @param {number[]} slices
 * @return {number}
 */
var maxSizeSlices = function(slices) {
    const total = slices.length;
    const k = Math.floor(total / 3);
    if (k === 0) return 0;
    const a = slices.slice(0, total - 1);
    const b = slices.slice(1);
    const best = function(nums, kk) {
        const n = nums.length;
        const NEG = -Infinity;
        const dp = [];
        for (let i = 0; i <= n; i++) {
            dp.push(new Array(kk + 1).fill(NEG));
            dp[i][0] = 0;
        }
        for (let i = 1; i <= n; i++) {
            for (let j = 1; j <= kk; j++) {
                const skip = dp[i - 1][j];
                let prev;
                if (i >= 2) prev = dp[i - 2][j - 1];
                else prev = (j === 1) ? 0 : NEG;
                const take = prev + nums[i - 1];
                dp[i][j] = Math.max(skip, take);
            }
        }
        return dp[n][kk];
    };
    return Math.max(best(a, k), best(b, k));
};
