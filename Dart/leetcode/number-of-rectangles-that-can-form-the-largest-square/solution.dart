class Solution {
  int countGoodRectangles(List<List<int>> rectangles) {
    int maxLen = 0;
    int count = 0;
    for (final r in rectangles) {
      int side = r[0] < r[1] ? r[0] : r[1];
      if (side > maxLen) {
        maxLen = side;
        count = 1;
      } else if (side == maxLen) {
        count += 1;
      }
    }
    return count;
  }
}
