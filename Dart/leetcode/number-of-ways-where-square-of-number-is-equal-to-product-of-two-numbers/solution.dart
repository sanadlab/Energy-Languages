class Solution {
  int _helper(List<int> a, List<int> b) {
    int cnt = 0;
    for (final x in a) {
      int t = x * x;
      Map<int, int> seen = {};
      for (final y in b) {
        if (t % y == 0) {
          int need = t ~/ y;
          cnt += seen[need] ?? 0;
        }
        seen[y] = (seen[y] ?? 0) + 1;
      }
    }
    return cnt;
  }

  int numTriplets(List<int> nums1, List<int> nums2) {
    return _helper(nums1, nums2) + _helper(nums2, nums1);
  }
}
