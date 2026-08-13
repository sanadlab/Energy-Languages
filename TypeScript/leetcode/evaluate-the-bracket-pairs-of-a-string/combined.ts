class Solution {
  evaluate(s: string, knowledge: string[][]): string {
    const map = new Map<string, string>();
    for (const [key, value] of knowledge) {
      map.set(key, value);
    }

    const regex = /\(([^)]+)\)/g;
    return s.replace(regex, (match) => {
      const key = match.substring(1, match.length - 1);
      return map.get(key) ?? '?';
    });
  }
}// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().evaluate("abcde", [["a","b"],["c","d"]])'); }
catch (_e) { _lc_test_result = eval('evaluate("abcde", [["a","b"],["c","d"]])'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
