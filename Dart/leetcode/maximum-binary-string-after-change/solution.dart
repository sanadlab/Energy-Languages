class Solution {
  String maximumBinaryString(String binary) {
    int n = binary.length;
    int first = binary.indexOf('0');
    if (first == -1) return binary;
    int zeros = 0;
    for (int i = 0; i < n; i++) {
      if (binary[i] == '0') zeros++;
    }
    List<String> res = List<String>.filled(n, '1');
    res[first + zeros - 1] = '0';
    return res.join();
  }
}
