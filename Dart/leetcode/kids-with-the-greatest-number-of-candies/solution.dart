class Solution {
  List<bool> kidsWithCandies(List<int> candies, int extraCandies) {
    int maxCandies = candies[0];
    for (final c in candies) {
      if (c > maxCandies) {
        maxCandies = c;
      }
    }
    return [for (final kid in candies) kid + extraCandies >= maxCandies];
  }
}
