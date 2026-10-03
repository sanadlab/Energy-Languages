class Solution {
  int removePalindromeSub(String s) {
    if (s.isEmpty) {
      return 0;
    }
    final reversed = String.fromCharCodes(s.codeUnits.reversed);
    return s == reversed ? 1 : 2;
  }
}
