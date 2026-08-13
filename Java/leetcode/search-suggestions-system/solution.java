import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class Solution {
    public List<List<String>> suggestedProducts(String[] products, String searchWord) {
        Arrays.sort(products); // Sort the products lexicographically
        List<List<String>> result = new ArrayList<>();
        
        for (int i = 0; i < searchWord.length(); i++) {
            StringBuilder prefix = new StringBuilder();
            for (int j = 0; j <= i; j++) {
                prefix.append(searchWord.charAt(j));
            }
            
            int count = 0;
            List<String> suggestions = new ArrayList<>();
            for (String product : products) {
                if (count == 3) break; // Limit to three suggestions
                if (product.startsWith(prefix.toString())) {
                    suggestions.add(product);
                    count++;
                }
            }
            result.add(suggestions);
        }
        
        return result;
    }
}