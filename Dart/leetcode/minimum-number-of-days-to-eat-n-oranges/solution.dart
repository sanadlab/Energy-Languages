class Solution {
  int minDays(int n) {
    Map<int, int> memo = {};
    int solve(int x) {
      if (x <= 1) return x;
      int? cached = memo[x];
      if (cached != null) return cached;
      int a = x % 2 + solve(x ~/ 2);
      int b = x % 3 + solve(x ~/ 3);
      int res = 1 + (a < b ? a : b);
      memo[x] = res;
      return res;
    }

    return solve(n);
  }
}
