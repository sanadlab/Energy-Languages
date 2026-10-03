class StreamChecker {
  Map<String, dynamic> trie = {};
  List<String> stream = [];
  int maxLen = 0;

  StreamChecker(List<String> words) {
    for (String w in words) {
      Map<String, dynamic> node = trie;
      for (int i = w.length - 1; i >= 0; i--) {
        String ch = w[i];
        node = node.putIfAbsent(ch, () => <String, dynamic>{})
            as Map<String, dynamic>;
      }
      node[r'$'] = true;
      if (w.length > maxLen) {
        maxLen = w.length;
      }
    }
  }

  bool query(String letter) {
    stream.add(letter);
    Map<String, dynamic> node = trie;
    int n = stream.length;
    int limit = maxLen < n ? maxLen : n;
    for (int step = 0; step < limit; step++) {
      String ch = stream[n - 1 - step];
      if (!node.containsKey(ch)) {
        return false;
      }
      node = node[ch] as Map<String, dynamic>;
      if (node[r'$'] == true) {
        return true;
      }
    }
    return false;
  }
}
