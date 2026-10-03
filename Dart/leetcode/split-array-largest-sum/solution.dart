class Solution {
  int splitArray(List<int> nums, int k) {
    int lo = nums[0];
    int hi = 0;
    for (int x in nums) {
      if (x > lo) {
        lo = x;
      }
      hi += x;
    }
    while (lo < hi) {
      int mid = (lo + hi) ~/ 2;
      int cnt = 1;
      int cur = 0;
      for (int x in nums) {
        if (cur + x > mid) {
          cnt += 1;
          cur = x;
        } else {
          cur += x;
        }
      }
      if (cnt <= k) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }
    return lo;
  }
}
