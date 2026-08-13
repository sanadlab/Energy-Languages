function longestStrChain(words: string[]): number {
    words.sort((a, b) => a.length - b.length);
    const dp = new Map<string, number>();
    let best = 1;
    for (const w of words) {
        let cur = 1;
        for (let i = 0; i < w.length; i++) {
            const pred = w.slice(0, i) + w.slice(i + 1);
            const v = dp.get(pred);
            if (v !== undefined && v + 1 > cur) cur = v + 1;
        }
        dp.set(w, cur);
        if (cur > best) best = cur;
    }
    return best;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().longestStrChain(["a","b","c"])'); }
catch (_e) { _lc_test_result = eval('longestStrChain(["a","b","c"])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
