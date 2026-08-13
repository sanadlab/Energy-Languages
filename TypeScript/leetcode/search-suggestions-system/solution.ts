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
