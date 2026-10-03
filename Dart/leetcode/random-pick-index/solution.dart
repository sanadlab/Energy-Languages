import 'dart:math';

class Solution {
  final List<int> _nums;
  final Random _rng = Random();

  Solution(List<int> nums) : _nums = nums;

  int pick(int target) {
    // Reservoir sampling: scan ALL positions whose value equals target and
    // keep each with probability 1/count, O(n) time and O(1) extra space.
    // Mirrors the Python reference exactly (same work per pick call).
    int count = 0;
    int res = -1;
    for (int i = 0; i < _nums.length; i++) {
      if (_nums[i] == target) {
        count++;
        if (_rng.nextInt(count) == 0) res = i; // 1-in-count chance
      }
    }
    return res;
  }
}

/**
 * Your Solution object will be instantiated and called as such:
 * Solution obj = Solution(nums);
 * int param1 = obj.pick(target);
 */
