class Solution {
  int longestStrChain(List<String> words) {
    words.sort((a, b) => a.length - b.length);
    final Map<String, int> dp = {};
    int best = 1;
    for (final w in words) {
      int cur = 1;
      for (int i = 0; i < w.length; i++) {
        final String pred = w.substring(0, i) + w.substring(i + 1);
        if (dp.containsKey(pred)) {
          final int cand = dp[pred]! + 1;
          if (cand > cur) cur = cand;
        }
      }
      dp[w] = cur;
      if (cur > best) best = cur;
    }
    return best;
  }
}
