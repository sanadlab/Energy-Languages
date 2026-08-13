function removeInvalidParentheses(s: string): string[] {
    const valid = (st: string): boolean => {
        let cnt = 0;
        for (const ch of st) {
            if (ch === '(') cnt++;
            else if (ch === ')') { cnt--; if (cnt < 0) return false; }
        }
        return cnt === 0;
    };
    let level = new Set<string>([s]);
    while (level.size > 0) {
        const valids: string[] = [];
        for (const st of level) if (valid(st)) valids.push(st);
        if (valids.length > 0) return valids;
        const nxt = new Set<string>();
        for (const st of level) {
            for (let i = 0; i < st.length; i++) {
                if (st[i] === '(' || st[i] === ')') {
                    nxt.add(st.slice(0, i) + st.slice(i + 1));
                }
            }
        }
        level = nxt;
    }
    return [""];
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().removeInvalidParentheses("abcde")'); }
catch (_e) { _lc_test_result = eval('removeInvalidParentheses("abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
