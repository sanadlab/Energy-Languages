class Solution {
  int maxSumTwoNoOverlap(List<int> nums, int firstLen, int secondLen) {
    int n = nums.length;
    List<int> pre = List<int>.filled(n + 1, 0);
    for (int i = 0; i < n; i++) {
      pre[i + 1] = pre[i] + nums[i];
    }
    int a = _best(firstLen, secondLen, pre, n);
    int b = _best(secondLen, firstLen, pre, n);
    return a > b ? a : b;
  }

  int _best(int L, int M, List<int> pre, int n) {
    int res = 0, maxL = 0;
    for (int i = L + M; i <= n; i++) {
      int cand = pre[i - M] - pre[i - M - L];
      if (cand > maxL) maxL = cand;
      int total = maxL + pre[i] - pre[i - M];
      if (total > res) res = total;
    }
    return res;
  }
}
