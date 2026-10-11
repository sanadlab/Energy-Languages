"use strict";
function ladderLength(beginWord, endWord, wordList) {
    const unvisited = new Set(wordList);
    if (!unvisited.has(endWord))
        return 0;
    let front = new Set([beginWord]);
    let back = new Set([endWord]);
    let length = 1;
    unvisited.delete(beginWord);
    unvisited.delete(endWord);
    while (front.size > 0 && back.size > 0) {
        if (front.size > back.size) {
            [front, back] = [back, front];
        }
        const next = new Set();
        for (const word of front) {
            for (let i = 0; i < word.length; i++) {
                const prefix = word.slice(0, i);
                const suffix = word.slice(i + 1);
                const original = word.charCodeAt(i);
                for (let code = 97; code <= 122; code++) {
                    if (code === original)
                        continue;
                    const candidate = prefix + String.fromCharCode(code) + suffix;
                    if (back.has(candidate))
                        return length + 1;
                    if (unvisited.delete(candidate)) {
                        next.add(candidate);
                    }
                }
            }
        }
        front = next;
        length++;
    }
    return 0;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().ladderLength("abcde", "abcde", ["a","b","c"])');
}
catch (_e) {
    _lc_test_result = eval('ladderLength("abcde", "abcde", ["a","b","c"])');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
