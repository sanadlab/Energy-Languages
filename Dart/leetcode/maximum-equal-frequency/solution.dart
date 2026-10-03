class Solution {
  int maxEqualFreq(List<int> nums) {
    int n = nums.length;
    List<int> count = List<int>.filled(100001, 0);
    List<int> freq = List<int>.filled(n + 1, 0);
    int maxF = 0;
    int res = 0;
    for (int i = 0; i < n; i++) {
      int v = nums[i];
      if (count[v] > 0) freq[count[v]]--;
      count[v]++;
      freq[count[v]]++;
      if (count[v] > maxF) maxF = count[v];
      if (maxF == 1 ||
          freq[maxF] * maxF == i ||
          (freq[maxF] == 1 && (maxF - 1) * (freq[maxF - 1] + 1) == i)) {
        res = i + 1;
      }
    }
    return res;
  }
}
