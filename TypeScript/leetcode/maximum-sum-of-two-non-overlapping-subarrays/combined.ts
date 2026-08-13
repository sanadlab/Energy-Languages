function maxSumTwoNoOverlap(nums: number[], firstLen: number, secondLen: number): number {
    const n = nums.length;
    const pre = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) pre[i + 1] = pre[i] + nums[i];
    const best = (L: number, M: number): number => {
        let res = 0, maxL = 0;
        for (let i = L + M; i <= n; i++) {
            maxL = Math.max(maxL, pre[i - M] - pre[i - M - L]);
            res = Math.max(res, maxL + pre[i] - pre[i - M]);
        }
        return res;
    };
    return Math.max(best(firstLen, secondLen), best(secondLen, firstLen));
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().maxSumTwoNoOverlap([1,2,3,4,5], 20, 20)'); }
catch (_e) { _lc_test_result = eval('maxSumTwoNoOverlap([1,2,3,4,5], 20, 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
