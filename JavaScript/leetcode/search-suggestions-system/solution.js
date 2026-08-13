/**
 * @param {string[]} products
 * @param {string} searchWord
 * @return {string[][]}
 */
var suggestedProducts = function(products, searchWord) {
    products.sort();
    const result = [];
    for (let i = 0; i < searchWord.length; i++) {
        const prefix = searchWord.substring(0, i + 1);
        const suggestions = [];
        for (const p of products) {
            if (p.startsWith(prefix)) {
                suggestions.push(p);
                if (suggestions.length === 3) break;
            }
        }
        result.push(suggestions);
    }
    return result;
};
