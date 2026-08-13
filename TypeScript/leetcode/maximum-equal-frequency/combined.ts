function maxEqualFreq(nums: number[]): number {
    const n = nums.length;
    const count = new Array(100001).fill(0);
    const freq = new Array(n + 1).fill(0);
    let maxF = 0, res = 0;
    for (let i = 0; i < n; i++) {
        const v = nums[i];
        if (count[v] > 0) freq[count[v]]--;
        count[v]++;
        freq[count[v]]++;
        if (count[v] > maxF) maxF = count[v];
        if (maxF === 1 ||
            freq[maxF] * maxF === i ||
            (freq[maxF] === 1 && (maxF - 1) * (freq[maxF - 1] + 1) === i)) {
            res = i + 1;
        }
    }
    return res;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().maxEqualFreq([1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('maxEqualFreq([1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
