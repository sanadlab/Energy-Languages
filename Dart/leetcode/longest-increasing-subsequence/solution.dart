class Solution {
  int lengthOfLIS(List<int> nums) {
    final List<int> tails = [];
    for (final x in nums) {
      // bisect_left: leftmost position where x can be inserted
      int lo = 0;
      int hi = tails.length;
      while (lo < hi) {
        final int mid = (lo + hi) ~/ 2;
        if (tails[mid] < x) {
          lo = mid + 1;
        } else {
          hi = mid;
        }
      }
      final int i = lo;
      if (i == tails.length) {
        tails.add(x);
      } else {
        tails[i] = x;
      }
    }
    return tails.length;
  }
}
