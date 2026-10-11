"use strict";
function nextBeautifulNumber(n) {
    // This balanced number is greater than every allowed input.
    let answer = 1224444;
    const minLength = String(n).length;
    const counts = new Array(8).fill(0);
    const generate = (value, remaining) => {
        if (value >= answer)
            return;
        if (remaining === 0) {
            if (value > n)
                answer = value;
            return;
        }
        for (let digit = 1; digit <= 7; digit++) {
            if (counts[digit] === 0)
                continue;
            counts[digit]--;
            generate(value * 10 + digit, remaining - 1);
            counts[digit]++;
        }
    };
    // Each selected digit d must occur exactly d times.
    for (let mask = 1; mask < (1 << 7); mask++) {
        counts.fill(0);
        let length = 0;
        for (let digit = 1; digit <= 7; digit++) {
            if ((mask & (1 << (digit - 1))) !== 0) {
                counts[digit] = digit;
                length += digit;
            }
        }
        if (length < minLength || length > 7)
            continue;
        generate(0, length);
    }
    return answer;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().nextBeautifulNumber(20)');
}
catch (_e) {
    _lc_test_result = eval('nextBeautifulNumber(20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
