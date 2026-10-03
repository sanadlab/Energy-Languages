class Solution {
  int nextBeautifulNumber(int n) {
    int x = n + 1;
    while (true) {
      List<int> cnt = List<int>.filled(10, 0);
      int t = x;
      while (t > 0) {
        cnt[t % 10] += 1;
        t ~/= 10;
      }
      bool ok = true;
      for (int d = 0; d < 10; d++) {
        if (cnt[d] != 0 && cnt[d] != d) {
          ok = false;
          break;
        }
      }
      if (ok) return x;
      x += 1;
    }
  }
}
