class Solution {
  bool areOccurrencesEqual(String s) {
    Map<String, int> counts = {};
    for (int i = 0; i < s.length; i++) {
      String ch = s[i];
      counts[ch] = (counts[ch] ?? 0) + 1;
    }
    Set<int> distinct = counts.values.toSet();
    return distinct.length == 1;
  }
}
