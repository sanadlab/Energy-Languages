function findKDistantIndices(nums: number[], key: number, k: number): number[] {
    const n = nums.length;
    const mark: boolean[] = new Array(n).fill(false);
    for (let j = 0; j < n; j++) {
        if (nums[j] === key) {
            const lo = Math.max(0, j - k);
            const hi = Math.min(n - 1, j + k);
            for (let i = lo; i <= hi; i++) mark[i] = true;
        }
    }
    const res: number[] = [];
    for (let i = 0; i < n; i++) if (mark[i]) res.push(i);
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().findKDistantIndices([1,2,3,4,5], 20, 20)'); }
catch (_e) { _lc_test_result = eval('findKDistantIndices([1,2,3,4,5], 20, 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
