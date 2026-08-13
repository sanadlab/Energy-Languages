function suggestedProducts(products: string[], searchWord: string): string[][] {
    products.sort();
    const result: string[][] = [];
    for (let i = 0; i < searchWord.length; i++) {
        const prefix = searchWord.substring(0, i + 1);
        const suggestions: string[] = [];
        for (const p of products) {
            if (p.startsWith(prefix)) {
                suggestions.push(p);
                if (suggestions.length === 3) break;
            }
        }
        result.push(suggestions);
    }
    return result;
}
// LC-energy test suite (TypeScript) — hardcoded single case.
let _lc_test_result: any;
// Shape-agnostic call: LC accepted solutions are sometimes a
// `class Solution` and sometimes a bare top-level function. eval
// keeps tsc from static-erroring on whichever name is absent.
try { _lc_test_result = eval('new Solution().suggestedProducts(["a","b","c"], "abcde")'); }
catch (_e) { _lc_test_result = eval('suggestedProducts(["a","b","c"], "abcde")'); }
if (_lc_test_result === undefined || _lc_test_result === null) {
    console.log('void return');
}
