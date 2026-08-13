function judgeCircle(moves: string): boolean {
    let x = 0, y = 0;
    for (const move of moves) {
        switch (move) {
            case 'R': x++; break;
            case 'L': x--; break;
            case 'U': y++; break;
            case 'D': y--; break;
        }
    }
    return x === 0 && y === 0;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().judgeCircle("abcde")'); }
catch (_e) { _lc_test_result = eval('judgeCircle("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
