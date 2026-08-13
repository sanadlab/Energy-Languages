function uncommonFromSentences(s1: string, s2: string): string[] {
    const cnt: Record<string, number> = {};
    for (const w of (s1 + " " + s2).split(" ")) {
        if (w === "") continue;
        cnt[w] = (cnt[w] || 0) + 1;
    }
    return Object.keys(cnt).filter(w => cnt[w] === 1);
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().uncommonFromSentences("abcde", "abcde")'); }
catch (_e) { _lc_test_result = eval('uncommonFromSentences("abcde", "abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
