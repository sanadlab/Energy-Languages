class Solution {
  int countVowelSubstrings(String word) {
    int result = 0;
    int n = word.length;
    const String vowels = "aeiou";
    for (int i = 0; i < n; i++) {
      List<bool> seen = List.filled(26, false);
      int count = 0;
      for (int j = i; j < n; j++) {
        if (vowels.indexOf(word[j]) < 0) break;
        int c = word.codeUnitAt(j) - 97;
        if (!seen[c]) {
          seen[c] = true;
          count++;
        }
        if (count == 5) result++;
      }
    }
    return result;
  }
}
