class Solution {
  int minOperations(String s) {
    int cnt = 0;
    int n = s.length;
    for (int i = 0; i < n; i++) {
      String expected = i % 2 == 0 ? '0' : '1';
      if (s[i] != expected) cnt++;
    }
    return cnt < n - cnt ? cnt : n - cnt;
  }
}
