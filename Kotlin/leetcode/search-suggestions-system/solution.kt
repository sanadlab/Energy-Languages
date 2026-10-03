class Solution {
    fun suggestedProducts(products: Array<String>, searchWord: String): List<List<String>> {
        products.sort()
        val suggestions = ArrayList<List<String>>()
        var prefix = ""
        for (ch in searchWord) {
            prefix += ch
            val matching = ArrayList<String>()
            for (product in products) {
                if (product.startsWith(prefix)) {
                    matching.add(product)
                    if (matching.size == 3) break
                }
            }
            suggestions.add(matching)
        }
        return suggestions
    }
}
