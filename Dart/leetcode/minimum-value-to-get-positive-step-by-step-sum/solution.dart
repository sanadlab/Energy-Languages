class Solution {
  int minStartValue(List<int> nums) {
    int prefix = 0;
    int minPrefix = 0;
    for (final x in nums) {
      prefix += x;
      if (prefix < minPrefix) minPrefix = prefix;
    }
    int cand = 1 - minPrefix;
    return cand > 1 ? cand : 1;
  }
}
