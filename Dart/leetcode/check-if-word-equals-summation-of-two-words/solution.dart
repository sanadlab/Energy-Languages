class Solution {
  bool isSumEqual(String firstWord, String secondWord, String targetWord) {
    int wordToNum(String word) {
      int num = 0;
      int base = 'a'.codeUnitAt(0);
      for (int i = 0; i < word.length; i++) {
        num = num * 10 + (word.codeUnitAt(i) - base);
      }
      return num;
    }

    return wordToNum(firstWord) + wordToNum(secondWord) == wordToNum(targetWord);
  }
}
