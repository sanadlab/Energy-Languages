class Solution {
  int ladderLength(String beginWord, String endWord, List<String> wordList) {
    Set<String> wordSet = wordList.toSet();
    if (!wordSet.contains(endWord)) return 0;

    List<String> qWord = [beginWord];
    List<int> qLevel = [1];
    int head = 0;
    Set<String> visited = {beginWord};
    const String alphabet = 'abcdefghijklmnopqrstuvwxyz';

    while (head < qWord.length) {
      String currentWord = qWord[head];
      int level = qLevel[head];
      head++;

      for (int i = 0; i < currentWord.length; i++) {
        for (int ci = 0; ci < 26; ci++) {
          String nextWord = currentWord.substring(0, i) +
              alphabet[ci] +
              currentWord.substring(i + 1);

          if (nextWord == endWord) return level + 1;

          if (wordSet.contains(nextWord) && !visited.contains(nextWord)) {
            qWord.add(nextWord);
            qLevel.add(level + 1);
            visited.add(nextWord);
          }
        }
      }
    }

    return 0;
  }
}
