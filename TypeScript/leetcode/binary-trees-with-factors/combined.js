function numFactoredBinaryTrees(arr) {
    const MOD = 1000000007;
    const BASE = 32768;
    const multiplyModulo = (a, b) => {
        const low = b % BASE;
        const high = Math.floor(b / BASE);
        return ((a * low) % MOD +
            ((a * high) % MOD) * BASE) % MOD;
    };
    arr.sort((a, b) => a - b);
    const dp = new Array(arr.length).fill(1);
    const indexByValue = new Map();
    let answer = 0;
    for (let i = 0; i < arr.length; i++) {
        for (let j = 0; j < i; j++) {
            if (arr[i] % arr[j] !== 0)
                continue;
            const otherFactor = arr[i] / arr[j];
            const k = indexByValue.get(otherFactor);
            if (k !== undefined) {
                dp[i] += multiplyModulo(dp[j], dp[k]);
                if (dp[i] >= MOD)
                    dp[i] -= MOD;
            }
        }
        indexByValue.set(arr[i], i);
        answer += dp[i];
        if (answer >= MOD)
            answer -= MOD;
    }
    return answer;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().numFactoredBinaryTrees([1,2,3,4,5])');
}
catch (_e) {
    _lc_test_result = eval('numFactoredBinaryTrees([1,2,3,4,5])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
