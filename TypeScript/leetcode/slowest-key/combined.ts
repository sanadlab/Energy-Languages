function slowestKey(releaseTimes: number[], keysPressed: string): string {
    let best = keysPressed[0];
    let bestDur = releaseTimes[0];
    for (let i = 1; i < releaseTimes.length; i++) {
        const dur = releaseTimes[i] - releaseTimes[i - 1];
        if (dur > bestDur || (dur === bestDur && keysPressed[i] > best)) {
            bestDur = dur;
            best = keysPressed[i];
        }
    }
    return best;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().slowestKey([1,2,3,4,5], "abcde")'); }
catch (_e) { _lc_test_result = eval('slowestKey([1,2,3,4,5], "abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
