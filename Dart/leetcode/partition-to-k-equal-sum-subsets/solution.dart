class Solution {
  bool canPartitionKSubsets(List<int> nums, int k) {
    if (k <= 0 || nums.length < k) return false;
    int total = 0;
    for (final x in nums) {
      total += x;
    }
    if (total % k != 0) return false;
    int target = total ~/ k;
    nums.sort((a, b) => b - a);
    if (nums[0] > target) return false;
    int n = nums.length;
    List<bool> used = List<bool>.filled(n, false);

    bool backtrack(int k, int cur, int start) {
      if (k == 0) return true;
      if (cur == target) return backtrack(k - 1, 0, 0);
      for (int i = start; i < n; i++) {
        if (used[i] || cur + nums[i] > target) continue;
        used[i] = true;
        if (backtrack(k, cur + nums[i], i + 1)) return true;
        used[i] = false;
        if (cur == 0) break;
      }
      return false;
    }

    return backtrack(k, 0, 0);
  }
}
