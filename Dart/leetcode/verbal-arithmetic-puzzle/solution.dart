class Solution {
  late List<String> _words;
  late String _result;
  late int _maxLen;
  Map<String, int> _assigned = {};
  List<bool> _used = List<bool>.filled(10, false);
  Set<String> _leading = {};

  bool _solve(int col, int row, int carry) {
    if (col == _maxLen) {
      return carry == 0;
    }
    if (row < _words.length) {
      String w = _words[row];
      if (col >= w.length) {
        return _solve(col, row + 1, carry);
      }
      String ch = w[w.length - 1 - col];
      if (_assigned.containsKey(ch)) {
        return _solve(col, row + 1, carry);
      }
      for (int d = 0; d < 10; d++) {
        if (!_used[d] && !(d == 0 && _leading.contains(ch))) {
          _used[d] = true;
          _assigned[ch] = d;
          if (_solve(col, row + 1, carry)) {
            return true;
          }
          _used[d] = false;
          _assigned.remove(ch);
        }
      }
      return false;
    }
    int s = carry;
    for (String w in _words) {
      if (col < w.length) {
        s += _assigned[w[w.length - 1 - col]]!;
      }
    }
    int digit = s % 10;
    int newCarry = s ~/ 10;
    String rch = _result[_maxLen - 1 - col];
    if (_assigned.containsKey(rch)) {
      if (_assigned[rch] == digit) {
        return _solve(col + 1, 0, newCarry);
      }
      return false;
    }
    if (_used[digit]) {
      return false;
    }
    if (digit == 0 && _leading.contains(rch)) {
      return false;
    }
    _used[digit] = true;
    _assigned[rch] = digit;
    if (_solve(col + 1, 0, newCarry)) {
      return true;
    }
    _used[digit] = false;
    _assigned.remove(rch);
    return false;
  }

  bool isSolvable(List<String> words, String result) {
    _maxLen = result.length;
    for (String w in words) {
      if (w.length > _maxLen) return false;
    }
    _words = words;
    _result = result;
    _assigned = {};
    _used = List<bool>.filled(10, false);
    _leading = {};
    for (String w in words) {
      if (w.length > 1) _leading.add(w[0]);
    }
    if (result.length > 1) _leading.add(result[0]);
    return _solve(0, 0, 0);
  }
}
