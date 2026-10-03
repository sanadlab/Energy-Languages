class Solution {
  int countVowelPermutation(int n) {
    int mod = 1000000007;
    int a = 1, e = 1, i = 1, o = 1, u = 1;
    for (int j = 2; j <= n; j++) {
      int aNext = (e + i + u) % mod;
      int eNext = (a + i) % mod;
      int iNext = (e + o) % mod;
      int oNext = i % mod;
      int uNext = (i + o) % mod;
      a = aNext;
      e = eNext;
      i = iNext;
      o = oNext;
      u = uNext;
    }
    return (a + e + i + o + u) % mod;
  }
}
