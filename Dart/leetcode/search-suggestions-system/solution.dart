class Solution {
  List<List<String>> suggestedProducts(List<String> products, String searchWord) {
    products.sort();

    final suggestions = <List<String>>[];
    var prefix = "";

    for (var i = 0; i < searchWord.length; i++) {
      prefix += searchWord[i];
      final matching = <String>[];
      for (final product in products) {
        if (product.startsWith(prefix)) {
          matching.add(product);
        }
      }
      suggestions.add(matching.length > 3 ? matching.sublist(0, 3) : matching);
    }

    return suggestions;
  }
}
