class Solution {
public:
    vector<vector<string>> suggestedProducts(vector<string>& products, string searchWord) {
        sort(products.begin(), products.end());
        vector<vector<string>> result;
        int n = searchWord.size();
        for (int i = 1; i <= n; i++) {
            string prefix = searchWord.substr(0, i);
            vector<string> suggestions;
            for (const string& product : products) {
                if ((int)product.size() >= i && product.compare(0, i, prefix) == 0) {
                    suggestions.push_back(product);
                    if (suggestions.size() == 3) break;
                }
            }
            result.push_back(suggestions);
        }
        return result;
    }
};
