class Solution {
  List<int> diStringMatch(String s) {
    int n = s.length, lo = 0, hi = n;
    List<int> res = List.filled(n + 1, 0);
    for (int i = 0; i < n; i++) {
      if (s[i] == 'I') {
        res[i] = lo;
        lo++;
      } else {
        res[i] = hi;
        hi--;
      }
    }
    res[n] = lo;
    return res;
  }
}
