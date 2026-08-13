public class Solution {
    public IList<IList<string>> SuggestedProducts(string[] products, string searchWord) {
        var sorted = products.OrderBy(p => p, StringComparer.Ordinal).ToList();
        var result = new List<IList<string>>();
        for (int i = 0; i < searchWord.Length; i++) {
            string prefix = searchWord.Substring(0, i + 1);
            var suggestions = new List<string>();
            foreach (var p in sorted) {
                if (p.StartsWith(prefix, StringComparison.Ordinal)) {
                    suggestions.Add(p);
                    if (suggestions.Count == 3) break;
                }
            }
            result.Add(suggestions);
        }
        return result;
    }
}
