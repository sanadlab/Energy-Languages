function countVowelSubstrings(word: string): number {
    const vowels = new Set(['a', 'e', 'i', 'o', 'u']);
    let count = 0;
    const n = word.length;
    for (let i = 0; i < n; i++) {
        const seen = new Set<string>();
        for (let j = i; j < n; j++) {
            if (!vowels.has(word[j])) break;
            seen.add(word[j]);
            if (seen.size === 5) count++;
        }
    }
    return count;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().countVowelSubstrings("abcde")'); }
catch (_e) { _lc_test_result = eval('countVowelSubstrings("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
