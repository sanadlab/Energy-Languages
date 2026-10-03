class Solution {
  int numFactoredBinaryTrees(List<int> arr) {
    arr.sort((a, b) => a - b);
    const int MOD = 1000000007;
    Map<int, int> dp = {};
    for (int i = 0; i < arr.length; i++) {
      int v = arr[i];
      int cnt = 1;
      for (int j = 0; j < i; j++) {
        int a = arr[j];
        if (v % a == 0) {
          int b = v ~/ a;
          if (dp.containsKey(b)) {
            cnt = (cnt + dp[a]! * dp[b]!) % MOD;
          }
        }
      }
      dp[v] = cnt % MOD;
    }
    int sum = 0;
    for (int val in dp.values) {
      sum = (sum + val) % MOD;
    }
    return sum % MOD;
  }
}
