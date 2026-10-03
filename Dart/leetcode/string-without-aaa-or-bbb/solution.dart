class Solution {
  String strWithout3a3b(int a, int b) {
    List<String> res = [];
    while (a > 0 || b > 0) {
      int n = res.length;
      bool writeA;
      if (n >= 2 && res[n - 1] == res[n - 2]) {
        writeA = res[n - 1] == 'b';
      } else {
        writeA = a >= b;
      }
      if (writeA) {
        if (a == 0) {
          break;
        }
        res.add('a');
        a -= 1;
      } else {
        if (b == 0) {
          break;
        }
        res.add('b');
        b -= 1;
      }
    }
    return res.join('');
  }
}
