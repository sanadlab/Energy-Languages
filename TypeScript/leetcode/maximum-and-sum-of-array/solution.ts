function maximumANDSum(nums: number[], numSlots: number): number {
    const n = nums.length;
    const full = (1 << n) - 1;
    let dp = new Array(1 << n).fill(-1);
    dp[0] = 0;
    for (let slot = 1; slot <= numSlots; slot++) {
        const ndp = dp.slice();
        for (let mask = 0; mask <= full; mask++) {
            if (dp[mask] < 0) continue;
            const base = dp[mask];
            for (let i = 0; i < n; i++) {
                if ((mask >> i) & 1) continue;
                const nm = mask | (1 << i);
                const v = base + (nums[i] & slot);
                if (v > ndp[nm]) ndp[nm] = v;
                for (let j = i + 1; j < n; j++) {
                    if ((mask >> j) & 1) continue;
                    const nm2 = nm | (1 << j);
                    const v2 = v + (nums[j] & slot);
                    if (v2 > ndp[nm2]) ndp[nm2] = v2;
                }
            }
        }
        dp = ndp;
    }
    return dp[full] < 0 ? 0 : dp[full];
}
