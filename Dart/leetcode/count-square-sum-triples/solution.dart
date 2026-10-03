import 'dart:math';

class Solution {
  int countTriples(int n) {
    int count = 0;
    for (int a = 1; a <= n; a++) {
      for (int b = a; b <= n; b++) {
        int cSquare = a * a + b * b;
        int c = sqrt(cSquare).toInt();
        if (c <= n && c * c == cSquare) {
          count += 2;
        }
      }
    }
    return count;
  }
}
