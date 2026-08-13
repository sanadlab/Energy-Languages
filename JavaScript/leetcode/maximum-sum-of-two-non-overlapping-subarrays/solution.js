/**
 * @param {number[]} nums
 * @param {number} firstLen
 * @param {number} secondLen
 * @return {number}
 */
var maxSumTwoNoOverlap = function(nums, firstLen, secondLen) {
    const n = nums.length;
    const pre = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) pre[i + 1] = pre[i] + nums[i];
    const best = (L, M) => {
        let res = 0, maxL = 0;
        for (let i = L + M; i <= n; i++) {
            maxL = Math.max(maxL, pre[i - M] - pre[i - M - L]);
            res = Math.max(res, maxL + pre[i] - pre[i - M]);
        }
        return res;
    };
    return Math.max(best(firstLen, secondLen), best(secondLen, firstLen));
};
