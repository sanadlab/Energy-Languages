class Solution {
    checkStraightLine(coordinates: number[][]): boolean {
        if (coordinates.length === 2) {
            return true;
        }
        
        const [x0, y0] = coordinates[0];
        const [x1, y1] = coordinates[1];
        
        for (let i = 2; i < coordinates.length; i++) {
            const [x, y] = coordinates[i];
            const crossProduct = (x1 - x0) * (y - y0) - (y1 - y0) * (x - x0);
            if (crossProduct !== 0) {
                return false;
            }
        }
        
        return true;
    }
}// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().checkStraightLine([[1,2],[3,4]])'); }
catch (_e) { _lc_test_result = eval('checkStraightLine([[1,2],[3,4]])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
