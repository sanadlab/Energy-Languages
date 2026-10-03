class Solution {
  List<int> sortByBits(List<int> arr) {
    int popcount(int x) {
      int c = 0;
      while (x != 0) {
        c += x & 1;
        x >>= 1;
      }
      return c;
    }

    List<int> res = List<int>.from(arr);
    res.sort((a, b) {
      int pa = popcount(a);
      int pb = popcount(b);
      if (pa != pb) {
        return pa - pb;
      }
      return a - b;
    });
    return res;
  }
}
