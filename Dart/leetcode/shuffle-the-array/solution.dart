class Solution {
  List<int> shuffle(List<int> nums, int n) {
    final res = <int>[];
    for (int i = 0; i < n; i++) { res.add(nums[i]); res.add(nums[i + n]); }
    return res;
  }
}
