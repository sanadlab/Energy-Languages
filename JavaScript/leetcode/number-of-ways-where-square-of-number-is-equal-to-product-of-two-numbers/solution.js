/**
 * @param {number[]} nums1
 * @param {number[]} nums2
 * @return {number}
 */
var numTriplets = function(nums1, nums2) {
    const helper = (a, b) => {
        let cnt = 0;
        for (const x of a) {
            const t = x * x;
            const seen = new Map();
            for (const y of b) {
                if (t % y === 0) {
                    const need = t / y;
                    cnt += seen.get(need) || 0;
                }
                seen.set(y, (seen.get(y) || 0) + 1);
            }
        }
        return cnt;
    };
    return helper(nums1, nums2) + helper(nums2, nums1);
};
