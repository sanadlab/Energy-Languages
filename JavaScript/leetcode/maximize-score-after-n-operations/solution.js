var maxScore = function(nums) {
    const m = nums.length;
    const dp = new Array(1 << m).fill(0);
    let best = 0;
    const gcd = (a, b) => { while (b) { const t = a % b; a = b; b = t; } return a; };
    for (let mask = 0; mask < (1 << m); mask++) {
        let cnt = 0; for (let x = mask; x > 0; x >>= 1) cnt += x & 1;
        if (cnt & 1) continue;
        const op = (cnt >> 1) + 1;
        for (let i = 0; i < m; i++) {
            if ((mask >> i) & 1) continue;
            for (let j = i + 1; j < m; j++) {
                if ((mask >> j) & 1) continue;
                const nm = mask | (1 << i) | (1 << j);
                const val = dp[mask] + op * gcd(nums[i], nums[j]);
                if (val > dp[nm]) dp[nm] = val;
                if (dp[nm] > best) best = dp[nm];
            }
        }
    }
    return best;
};
