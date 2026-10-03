class Solution {
  String evaluate(String s, List<List<String>> knowledge) {
    final Map<String, String> knowledgeDict = {};
    for (final kv in knowledge) {
      knowledgeDict[kv[0]] = kv[1];
    }

    final List<String> stack = [];
    String word = "";
    for (int i = 0; i < s.length; i++) {
      final String char = s[i];
      if (char == "(") {
        stack.add(word);
        word = "";
      } else if (char == ")") {
        final String prevWord = stack.removeLast() + (knowledgeDict[word] ?? "?");
        word = prevWord;
      } else {
        word += char;
      }
    }

    return word;
  }
}
