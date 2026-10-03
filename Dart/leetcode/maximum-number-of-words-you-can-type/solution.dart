class Solution {
  int canBeTypedWords(String text, String brokenLetters) {
    Set<String> broken = brokenLetters.split('').toSet();
    int count = 0;
    for (String word in text.split(' ')) {
      if (word.isEmpty) continue;
      bool ok = true;
      for (int i = 0; i < word.length; i++) {
        if (broken.contains(word[i])) {
          ok = false;
          break;
        }
      }
      if (ok) count++;
    }
    return count;
  }
}
