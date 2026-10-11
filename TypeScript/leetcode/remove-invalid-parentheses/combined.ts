function removeInvalidParentheses(s: string): string[] {
    const result: string[] = [];

    function search(
        current: string,
        scanStart: number,
        removeStart: number,
        open: string,
        close: string
    ): void {
        let balance = 0;

        for (let i = scanStart; i < current.length; i++) {
            if (current[i] === open) balance++;
            else if (current[i] === close) balance--;

            if (balance >= 0) continue;

            for (let j = removeStart; j <= i; j++) {
                if (
                    current[j] === close &&
                    (j === removeStart || current[j - 1] !== close)
                ) {
                    search(
                        current.slice(0, j) + current.slice(j + 1),
                        i,
                        j,
                        open,
                        close
                    );
                }
            }
            return;
        }

        const reversed = current.split("").reverse().join("");

        if (open === "(") {
            search(reversed, 0, 0, ")", "(");
        } else {
            result.push(reversed);
        }
    }

    search(s, 0, 0, "(", ")");
    return result;
};// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().removeInvalidParentheses("abcde")'); }
catch (_e) { _lc_test_result = eval('removeInvalidParentheses("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
