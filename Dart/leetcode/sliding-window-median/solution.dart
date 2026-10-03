class Solution {
  List<double> medianSlidingWindow(List<int> nums, int k) {
    List<double> res = [];
    int n = nums.length;
    for (int i = 0; i <= n - k; i++) {
      List<int> w = nums.sublist(i, i + k);
      w.sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));
      double median;
      if (k % 2 == 1) {
        median = w[k ~/ 2].toDouble();
      } else {
        median = (w[k ~/ 2 - 1] + w[k ~/ 2]) / 2.0;
      }
      res.add(median);
    }
    return res;
  }
}
