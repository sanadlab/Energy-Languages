function maxTotalFruits(fruits: number[][], startPos: number, k: number): number {
    const cost = (posL: number, posR: number): number => {
        if (posR <= startPos) return startPos - posL;
        if (posL >= startPos) return posR - startPos;
        return (posR - posL) + Math.min(startPos - posL, posR - startPos);
    };
    const n = fruits.length;
    let best = 0, sum = 0, i = 0;
    for (let j = 0; j < n; j++) {
        sum += fruits[j][1];
        while (i <= j && cost(fruits[i][0], fruits[j][0]) > k) {
            sum -= fruits[i][1];
            i++;
        }
        if (i <= j && sum > best) best = sum;
    }
    return best;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().maxTotalFruits([[1,2],[3,4]], 20, 20)'); }
catch (_e) { _lc_test_result = eval('maxTotalFruits([[1,2],[3,4]], 20, 20)'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
