function strWithout3a3b(a: number, b: number): string {
    const res: string[] = [];
    while (a > 0 || b > 0) {
        let writeA: boolean;
        const n = res.length;
        if (n >= 2 && res[n-1] === res[n-2]) writeA = res[n-1] === 'b';
        else writeA = a >= b;
        if (writeA) {
            if (a === 0) break;
            res.push('a'); a--;
        } else {
            if (b === 0) break;
            res.push('b'); b--;
        }
    }
    return res.join('');
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().strWithout3a3b(20, 20)'); }
catch (_e) { _lc_test_result = eval('strWithout3a3b(20, 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
