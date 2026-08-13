function canBeTypedWords(text: string, brokenLetters: string): number {
    const broken = new Set(brokenLetters);
    let count = 0;
    for (const word of text.split(' ')) {
        let ok = true;
        for (const c of word) {
            if (broken.has(c)) { ok = false; break; }
        }
        if (ok) count++;
    }
    return count;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().canBeTypedWords("abcde", "abcde")'); }
catch (_e) { _lc_test_result = eval('canBeTypedWords("abcde", "abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
