class Solution {
  List<int> findKDistantIndices(List<int> nums, int key, int k) {
    final List<int> result = [];
    final int n = nums.length;
    for (int i = 0; i < n; i++) {
      bool found = false;
      for (int j = 0; j < n; j++) {
        if ((i - j).abs() <= k && nums[j] == key) {
          found = true;
          break;
        }
      }
      if (found) {
        result.add(i);
      }
    }
    return result;
  }
}
