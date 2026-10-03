class Solution {
  bool canCross(List<int> stones) {
    if (stones[1] != 1) {
      return false;
    }

    final Set<int> stoneSet = stones.toSet();
    final Map<int, Set<int>> dp = {};
    for (final stone in stones) {
      dp[stone] = <int>{};
    }

    dp[1]!.add(1);

    for (final stone in stones) {
      for (final k in dp[stone]!) {
        for (final step in [k - 1, k, k + 1]) {
          if (step > 0 && stoneSet.contains(stone + step)) {
            dp[stone + step]!.add(step);
          }
        }
      }
    }

    return dp[stones[stones.length - 1]]!.isNotEmpty;
  }
}
