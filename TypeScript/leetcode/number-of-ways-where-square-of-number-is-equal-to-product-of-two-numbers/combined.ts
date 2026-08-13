function numTriplets(nums1: number[], nums2: number[]): number {
    const helper = (a: number[], b: number[]): number => {
        let cnt = 0;
        for (const x of a) {
            const t = x * x;
            const seen = new Map<number, number>();
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
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().numTriplets([1,2,3,4,5], [1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('numTriplets([1,2,3,4,5], [1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
