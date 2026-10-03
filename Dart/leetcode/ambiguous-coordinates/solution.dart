class Solution {
  List<String> ambiguousCoordinates(String s) {
    String digits = s.substring(1, s.length - 1);
    int n = digits.length;
    List<String> res = [];
    for (int i = 1; i < n; i++) {
      for (String a in make(digits.substring(0, i))) {
        for (String b in make(digits.substring(i))) {
          res.add("($a, $b)");
        }
      }
    }
    return res;
  }

  List<String> make(String d) {
    List<String> out = [];
    int n = d.length;
    if (n == 1) {
      out.add(d);
      return out;
    }
    if (d[0] != '0') {
      out.add(d);
    }
    for (int i = 1; i < n; i++) {
      String l = d.substring(0, i);
      String r = d.substring(i);
      if ((l == "0" || l[0] != '0') && r[r.length - 1] != '0') {
        out.add("$l.$r");
      }
    }
    return out;
  }
}
