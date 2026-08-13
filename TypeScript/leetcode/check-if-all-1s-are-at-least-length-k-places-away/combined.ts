function kLengthApart(nums: number[], k: number): boolean {
    let prev = -1;
    for (let i = 0; i < nums.length; i++) {
        if (nums[i] === 1) {
            if (prev !== -1 && i - prev - 1 < k) {
                return false;
            }
            prev = i;
        }
    }
    return true;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().kLengthApart([1,2,3,4,5], 20)'); }
catch (_e) { _lc_test_result = eval('kLengthApart([1,2,3,4,5], 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
