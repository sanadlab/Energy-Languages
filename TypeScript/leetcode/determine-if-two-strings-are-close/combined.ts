function closeStrings(word1: string, word2: string): boolean {
    if (word1.length !== word2.length) return false;
    const c1: number[] = new Array(26).fill(0);
    const c2: number[] = new Array(26).fill(0);
    for (const ch of word1) c1[ch.charCodeAt(0) - 97]++;
    for (const ch of word2) c2[ch.charCodeAt(0) - 97]++;
    for (let i = 0; i < 26; i++) {
        if ((c1[i] === 0) !== (c2[i] === 0)) return false;
    }
    c1.sort((a, b) => a - b);
    c2.sort((a, b) => a - b);
    for (let i = 0; i < 26; i++) {
        if (c1[i] !== c2[i]) return false;
    }
    return true;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().closeStrings("abcde", "abcde")'); }
catch (_e) { _lc_test_result = eval('closeStrings("abcde", "abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
