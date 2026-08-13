function nextGreaterElements(nums: number[]): number[] {
    const n = nums.length;
    const res: number[] = new Array(n).fill(-1);
    const st: number[] = [];
    for (let i = 0; i < 2 * n; i++) {
        const cur = nums[i % n];
        while (st.length && nums[st[st.length - 1]] < cur) {
            const idx = st.pop() as number;
            res[idx] = cur;
        }
        if (i < n) st.push(i);
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().nextGreaterElements([1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('nextGreaterElements([1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
