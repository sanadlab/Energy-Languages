function numTriplets(nums1: number[], nums2: number[]): number {
    function countTriplets(singles: number[], pairs: number[]): number {
        const squareCounts = new Map<number, number>();

        for (const value of singles) {
            const square = value * value;
            squareCounts.set(square, (squareCounts.get(square) ?? 0) + 1);
        }

        let count = 0;

        for (let j = 0; j < pairs.length; j++) {
            for (let k = j + 1; k < pairs.length; k++) {
                count += squareCounts.get(pairs[j] * pairs[k]) ?? 0;
            }
        }

        return count;
    }

    return countTriplets(nums1, nums2) + countTriplets(nums2, nums1);
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().numTriplets([1,2,3,4,5], [1,2,3,4,5])'); }
catch (_e) { _lc_test_result = eval('numTriplets([1,2,3,4,5], [1,2,3,4,5])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
