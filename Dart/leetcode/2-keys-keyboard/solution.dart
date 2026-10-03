class Solution {
  int minSteps(int n) {
    int res = 0;
    int d = 2;
    while (n > 1) {
      while (n % d == 0) {
        res += d;
        n ~/= d;
      }
      d += 1;
    }
    return res;
  }
}
