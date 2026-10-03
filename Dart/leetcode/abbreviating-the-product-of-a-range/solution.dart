class Solution {
  String abbreviateProduct(int left, int right) {
    BigInt p = BigInt.one;
    for (int i = left; i <= right; i++) {
      p *= BigInt.from(i);
    }
    final BigInt ten = BigInt.from(10);
    int c = 0;
    while (p % ten == BigInt.zero) {
      p = p ~/ ten;
      c += 1;
    }
    String s = p.toString();
    if (s.length <= 10) {
      return "${s}e$c";
    }
    return "${s.substring(0, 5)}...${s.substring(s.length - 5)}e$c";
  }
}
