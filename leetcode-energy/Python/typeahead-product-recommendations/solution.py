from typing import List
import bisect

class Solution:
    def suggestedProducts(self, products: List[str], searchWord: str) -> List[List[str]]:
        products.sort()
        result = []
        prefix = ""
        for ch in searchWord:
            prefix += ch
            # Find the leftmost index to insert prefix
            i = bisect.bisect_left(products, prefix)
            suggestions = []
            # Collect up to 3 products starting with prefix
            for j in range(i, min(i + 3, len(products))):
                if products[j].startswith(prefix):
                    suggestions.append(products[j])
                else:
                    break
            result.append(suggestions)
        return result
