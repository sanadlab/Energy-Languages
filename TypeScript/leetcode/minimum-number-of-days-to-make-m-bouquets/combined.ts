function minDays(bloomDay: number[], m: number, k: number): number {
    if (m * k > bloomDay.length) return -1;
    let lo = bloomDay[0], hi = bloomDay[0];
    for (const b of bloomDay) { if (b < lo) lo = b; if (b > hi) hi = b; }
    const canMake = (day: number): boolean => {
        let bouquets = 0, flowers = 0;
        for (const b of bloomDay) {
            if (b <= day) {
                flowers++;
                if (flowers === k) { bouquets++; flowers = 0; }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    };
    while (lo < hi) {
        const mid = Math.floor((lo + hi) / 2);
        if (canMake(mid)) hi = mid;
        else lo = mid + 1;
    }
    return lo;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().minDays([1,2,3,4,5], 20, 20)'); }
catch (_e) { _lc_test_result = eval('minDays([1,2,3,4,5], 20, 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
