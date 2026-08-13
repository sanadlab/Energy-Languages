"use strict";
function maximumBeauty(flowers, newFlowers, target, full, partial) {
    const n = flowers.length;
    if (n === 0)
        return 0;
    const fl = flowers.map(f => Math.min(f, target)).sort((a, b) => a - b);
    const pre = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++)
        pre[i + 1] = pre[i] + fl[i];
    if (fl[0] === target)
        return full * n;
    const lowerBound = (hiIdx, v) => {
        let lo = 0, hi = hiIdx;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (fl[mid] < v)
                lo = mid + 1;
            else
                hi = mid;
        }
        return lo;
    };
    let ans = 0;
    for (let i = n; i >= 0; i--) {
        const costComplete = target * (n - i) - (pre[n] - pre[i]);
        if (costComplete > newFlowers)
            continue;
        const rem = newFlowers - costComplete;
        if (i === 0) {
            ans = Math.max(ans, full * (n - i));
            continue;
        }
        let lo = 0, hi = target - 1, bestMin = 0;
        while (lo <= hi) {
            const v = lo + ((hi - lo) >> 1);
            const k = lowerBound(i, v);
            const cost = v * k - pre[k];
            if (cost <= rem) {
                bestMin = v;
                lo = v + 1;
            }
            else {
                hi = v - 1;
            }
        }
        ans = Math.max(ans, full * (n - i) + bestMin * partial);
    }
    return ans;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().maximumBeauty([1,2,3,4,5], 20, 20, 20, 20)');
}
catch (_e) {
    _lc_test_result = eval('maximumBeauty([1,2,3,4,5], 20, 20, 20, 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
