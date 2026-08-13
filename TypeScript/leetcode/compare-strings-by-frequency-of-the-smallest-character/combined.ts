function numSmallerByFrequency(queries: string[], words: string[]): number[] {
    const f = (s: string): number => {
        let mn = 'z';
        let cnt = 0;
        for (const c of s) {
            if (c < mn) { mn = c; cnt = 1; }
            else if (c === mn) cnt++;
        }
        return cnt;
    };
    const wf = words.map(f);
    return queries.map(q => {
        const fq = f(q);
        return wf.filter(v => v > fq).length;
    });
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().numSmallerByFrequency(["a","b","c"], ["a","b","c"])'); }
catch (_e) { _lc_test_result = eval('numSmallerByFrequency(["a","b","c"], ["a","b","c"])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
