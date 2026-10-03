class Solution {
  List<String> removeInvalidParentheses(String s) {
    bool valid(String st) {
      var cnt = 0;
      for (var i = 0; i < st.length; i++) {
        final ch = st[i];
        if (ch == '(') {
          cnt += 1;
        } else if (ch == ')') {
          cnt -= 1;
          if (cnt < 0) {
            return false;
          }
        }
      }
      return cnt == 0;
    }

    var level = <String>{s};
    while (level.isNotEmpty) {
      final valids = <String>[];
      for (final st in level) {
        if (valid(st)) valids.add(st);
      }
      if (valids.isNotEmpty) {
        return valids;
      }
      final nxt = <String>{};
      for (final st in level) {
        for (var i = 0; i < st.length; i++) {
          if (st[i] == '(' || st[i] == ')') {
            nxt.add(st.substring(0, i) + st.substring(i + 1));
          }
        }
      }
      level = nxt;
    }
    return [""];
  }
}
