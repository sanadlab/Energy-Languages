class Solution {
  List<String> uncommonFromSentences(String s1, String s2) {
    // Combine both sentences and split into words.
    String combined = s1 + " " + s2;
    List<String> allWords =
        combined.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    // Count the occurrences of each word (insertion order preserved).
    Map<String, int> wordCount = {};
    for (String w in allWords) {
      wordCount[w] = (wordCount[w] ?? 0) + 1;
    }

    // Filter words that appear exactly once.
    List<String> uncommonWords = [];
    wordCount.forEach((word, count) {
      if (count == 1) uncommonWords.add(word);
    });

    return uncommonWords;
  }
}
