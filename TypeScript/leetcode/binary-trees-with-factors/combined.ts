function numFactoredBinaryTrees(arr: number[]): number {
    arr.sort((a, b) => a - b);
    const MOD = 1000000007n;
    const dp = new Map<number, bigint>();
    let ans = 0n;
    for (let i = 0; i < arr.length; i++) {
        let cnt = 1n;
        for (let j = 0; j < i; j++) {
            if (arr[i] % arr[j] === 0) {
                const b = arr[i] / arr[j];
                const bv = dp.get(b);
                if (bv !== undefined) {
                    cnt = (cnt + (dp.get(arr[j]) as bigint) * bv) % MOD;
                }
            }
        }
        dp.set(arr[i], cnt);
        ans = (ans + cnt) % MOD;
    }
    return Number(ans);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().numFactoredBinaryTrees([1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('numFactoredBinaryTrees([1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
