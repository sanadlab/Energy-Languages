class Solution {
  int sumOddLengthSubarrays(List<int> arr) {
    int n = arr.length;
    int total = 0;
    for (int i = 0; i < n; i++) {
      int count = ((i + 1) * (n - i) + 1) ~/ 2;
      total += count * arr[i];
    }
    return total;
  }
}
