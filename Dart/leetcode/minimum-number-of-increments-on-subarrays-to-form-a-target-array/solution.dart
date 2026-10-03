class Solution {
  int minNumberOperations(List<int> target) {
    if (target.isEmpty) return 0;
    int ans = target[0];
    for (int i = 1; i < target.length; i++) {
      if (target[i] > target[i - 1]) {
        ans += target[i] - target[i - 1];
      }
    }
    return ans;
  }
}
