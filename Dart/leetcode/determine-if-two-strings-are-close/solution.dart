class Solution {
  bool closeStrings(String word1, String word2) {
    if (word1.length != word2.length) return false;

    List<int> count1 = List.filled(26, 0);
    List<int> count2 = List.filled(26, 0);

    for (int i = 0; i < word1.length; i++) {
      count1[word1.codeUnitAt(i) - 97]++;
    }
    for (int i = 0; i < word2.length; i++) {
      count2[word2.codeUnitAt(i) - 97]++;
    }

    for (int i = 0; i < 26; i++) {
      if ((count1[i] == 0 && count2[i] != 0) ||
          (count1[i] != 0 && count2[i] == 0)) {
        return false;
      }
    }

    count1.sort();
    count2.sort();

    for (int i = 0; i < 26; i++) {
      if (count1[i] != count2[i]) return false;
    }

    return true;
  }
}
