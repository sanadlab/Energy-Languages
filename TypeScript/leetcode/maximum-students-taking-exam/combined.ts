function maxStudents(seats: string[][]): number {
    const m = seats.length;
    const n = seats[0].length;
    const limit = 1 << n;

    const counts = new Uint8Array(limit);
    const validMasks: number[] = [];

    for (let mask = 0; mask < limit; mask++) {
        counts[mask] = counts[mask >> 1] + (mask & 1);
        if ((mask & (mask << 1)) === 0) {
            validMasks.push(mask);
        }
    }

    let dp = new Int32Array(limit).fill(-1);
    dp[0] = 0;

    for (let row = 0; row < m; row++) {
        let available = 0;
        for (let col = 0; col < n; col++) {
            if (seats[row][col] === ".") {
                available |= 1 << col;
            }
        }

        const next = new Int32Array(limit).fill(-1);

        for (const mask of validMasks) {
            if ((mask & available) !== mask) continue;

            for (const previous of validMasks) {
                if (dp[previous] === -1) continue;
                if ((mask & (previous << 1)) !== 0) continue;
                if ((mask & (previous >> 1)) !== 0) continue;

                next[mask] = Math.max(
                    next[mask],
                    dp[previous] + counts[mask]
                );
            }
        }

        dp = next;
    }

    let answer = 0;
    for (const mask of validMasks) {
        answer = Math.max(answer, dp[mask]);
    }
    return answer;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().maxStudents([["a","b"],["c","d"]])'); }
catch (_e) { _lc_test_result = eval('maxStudents([["a","b"],["c","d"]])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
