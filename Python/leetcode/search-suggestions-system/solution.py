from typing import List

class Solution:
    def suggestedProducts(self, products: List[str], searchWord: str) -> List[List[str]]:
        # Sort the products lexicographically
        products.sort()
        
        suggestions = []
        prefix = ""
        
        for char in searchWord:
            prefix += char
            matching_products = [product for product in products if product.startswith(prefix)]
            
            # Take at most 3 products
            suggestions.append(matching_products[:3])
        
        return suggestions