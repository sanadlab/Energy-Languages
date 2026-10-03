class Solution {
  List<int> minSubsequence(List<int> nums) {
    nums.sort((a, b) => b - a);
    int total = 0;
    for (final x in nums) {
      total += x;
    }
    int running = 0;
    List<int> res = [];
    for (final x in nums) {
      running += x;
      res.add(x);
      if (running * 2 > total) break;
    }
    return res;
  }
}
