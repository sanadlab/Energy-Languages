class Solution {
  String licenseKeyFormatting(String s, int k) {
    final String cleaned = s.replaceAll('-', '').toUpperCase();

    final int firstGroupLen = cleaned.length % k;

    final List<String> result = [];
    if (firstGroupLen > 0) {
      result.add(cleaned.substring(0, firstGroupLen));
    }

    for (int i = firstGroupLen; i < cleaned.length; i += k) {
      result.add(cleaned.substring(i, i + k));
    }

    return result.join('-');
  }
}
