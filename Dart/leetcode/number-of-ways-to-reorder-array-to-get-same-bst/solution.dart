class Solution {
  int numOfWays(List<int> nums) {
    const int MOD = 1000000007;
    int n = nums.length;
    List<List<int>> C =
        List.generate(n + 1, (_) => List<int>.filled(n + 1, 0));
    for (int i = 0; i <= n; i++) {
      C[i][0] = 1;
      for (int j = 1; j <= i; j++) {
        C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD;
      }
    }
    // ways(arr) = product over every subtree of C[size-1][leftSize].
    // Base cases (size <= 2) contribute a factor of 1, so we skip them.
    // Iterative decomposition avoids deep recursion.
    int result = 1;
    List<List<int>> stack = [nums];
    while (stack.isNotEmpty) {
      List<int> arr = stack.removeLast();
      int m = arr.length;
      if (m <= 2) continue;
      int root = arr[0];
      List<int> left = [];
      List<int> right = [];
      for (int idx = 1; idx < m; idx++) {
        int x = arr[idx];
        if (x < root) {
          left.add(x);
        } else if (x > root) {
          right.add(x);
        }
      }
      result = result * C[m - 1][left.length] % MOD;
      stack.add(left);
      stack.add(right);
    }
    return (result - 1) % MOD;
  }
}
