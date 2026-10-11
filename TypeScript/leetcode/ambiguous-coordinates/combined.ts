function ambiguousCoordinates(s: string): string[] {
    const digits = s.slice(1, -1);
    const result: string[] = [];

    function representations(part: string): string[] {
        const options: string[] = [];

        if (part.length === 1 || part[0] !== "0") {
            options.push(part);
        }

        if (part[part.length - 1] === "0") {
            return options;
        }

        for (let i = 1; i < part.length; i++) {
            if (i > 1 && part[0] === "0") {
                break;
            }

            options.push(part.slice(0, i) + "." + part.slice(i));
        }

        return options;
    }

    for (let split = 1; split < digits.length; split++) {
        const left = representations(digits.slice(0, split));
        const right = representations(digits.slice(split));

        for (const x of left) {
            for (const y of right) {
                result.push(`(${x}, ${y})`);
            }
        }
    }

    return result;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().ambiguousCoordinates("abcde")'); }
catch (_e) { _lc_test_result = eval('ambiguousCoordinates("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
