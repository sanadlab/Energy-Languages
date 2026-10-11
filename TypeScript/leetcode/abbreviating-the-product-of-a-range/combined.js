"use strict";
function abbreviateProduct(left, right) {
    let product = 1n;
    for (let value = left; value <= right; value++) {
        product *= BigInt(value);
    }
    const digits = product.toString();
    let end = digits.length;
    while (digits[end - 1] === "0") {
        end--;
    }
    const zeros = digits.length - end;
    if (end <= 10) {
        return `${digits.slice(0, end)}e${zeros}`;
    }
    const firstFive = digits.slice(0, 5);
    const lastFive = digits.slice(end - 5, end);
    return `${firstFive}...${lastFive}e${zeros}`;
}
; // LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try {
    _lc_test_result = eval('new Solution().abbreviateProduct(20, 20)');
}
catch (_e) {
    _lc_test_result = eval('abbreviateProduct(20, 20)');
}
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
