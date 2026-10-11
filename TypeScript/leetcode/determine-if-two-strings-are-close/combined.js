"use strict";
function closeStrings(word1, word2) {
    if (word1.length !== word2.length)
        return false;
    const count1 = new Array(26).fill(0);
    const count2 = new Array(26).fill(0);
    for (let i = 0; i < word1.length; i++) {
        count1[word1.charCodeAt(i) - 97]++;
        count2[word2.charCodeAt(i) - 97]++;
    }
    for (let i = 0; i < 26; i++) {
        if ((count1[i] === 0) !== (count2[i] === 0))
            return false;
    }
    count1.sort((a, b) => a - b);
    count2.sort((a, b) => a - b);
    for (let i = 0; i < 26; i++) {
        if (count1[i] !== count2[i])
            return false;
    }
    return true;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().closeStrings("abcde", "abcde")');
}
catch (_e) {
    _lc_test_result = eval('closeStrings("abcde", "abcde")');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
