/**
 * @param {number[]} nums
 * @return {number}
 */
var numOfWays = function(nums) {
    const MOD = 1000000007n;
    const n = nums.length;
    const C = [];
    for (let i = 0; i <= n; i++) {
        C.push(new Array(n + 1).fill(0n));
        C[i][0] = 1n;
        for (let j = 1; j <= i; j++)
            C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD;
    }
    const ways = (arr) => {
        const m = arr.length;
        if (m <= 2) return 1n;
        const root = arr[0];
        const left = [], right = [];
        for (let i = 1; i < m; i++) {
            if (arr[i] < root) left.push(arr[i]);
            else right.push(arr[i]);
        }
        return C[m - 1][left.length] * ways(left) % MOD * ways(right) % MOD;
    };
    return Number((ways(nums) - 1n + MOD) % MOD);
};
