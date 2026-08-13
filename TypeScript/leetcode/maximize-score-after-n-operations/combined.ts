function maxScore(nums: number[]): number {
    const m = nums.length;
    const dp = new Array(1 << m).fill(0);
    let best = 0;
    const gcd = (a: number, b: number): number => { while (b) { const t = a % b; a = b; b = t; } return a; };
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
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().maxScore([1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('maxScore([1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
