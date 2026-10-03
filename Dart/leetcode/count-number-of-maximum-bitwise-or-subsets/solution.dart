class Solution {
  int countMaxOrSubsets(List<int> nums) {
    int maxOr = 0;
    for (int num in nums) {
      maxOr |= num;
    }

    int n = nums.length;
    int count = 0;
    int totalSubsets = 1 << n;
    for (int mask = 1; mask < totalSubsets; mask++) {
      int cur = 0;
      for (int j = 0; j < n; j++) {
        if ((mask & (1 << j)) != 0) {
          cur |= nums[j];
        }
      }
      if (cur == maxOr) {
        count++;
      }
    }
    return count;
  }
}
