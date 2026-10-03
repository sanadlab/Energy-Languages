class Solution {
  Map<int, List<int>> _memo = {};

  List<int> _dp(int m, int f, int s) {
    if (f > s) {
      int t = f;
      f = s;
      s = t;
    }
    int key = ((m * 100) + f) * 100 + s;
    List<int>? cached = _memo[key];
    if (cached != null) return cached;

    if (f + s == m + 1) {
      List<int> r = [1, 1];
      _memo[key] = r;
      return r;
    }

    int newM = (m + 1) ~/ 2;
    List<List<int>> groups = [];
    for (int p = 1; p <= m ~/ 2; p++) {
      int q = m + 1 - p;
      if (f == p || f == q) {
        groups.add([f]);
      } else if (s == p || s == q) {
        groups.add([s]);
      } else {
        groups.add([p, q]);
      }
    }
    if (m % 2 == 1) {
      groups.add([(m + 1) ~/ 2]);
    }

    // product over groups, accumulating (below_f, below_s) counts.
    Set<int> partial = {0}; // encoded as below_f * 100 + below_s
    for (List<int> group in groups) {
      Set<int> next = {};
      for (int enc in partial) {
        int bf = enc ~/ 100;
        int bs = enc % 100;
        for (int w in group) {
          int nbf = bf + (w < f ? 1 : 0);
          int nbs = bs + (w < s ? 1 : 0);
          next.add(nbf * 100 + nbs);
        }
      }
      partial = next;
    }

    Set<int> outcomes = {};
    for (int enc in partial) {
      int bf = enc ~/ 100;
      int bs = enc % 100;
      outcomes.add((bf + 1) * 100 + (bs + 1));
    }

    int earliest = 1 << 30;
    int latest = -(1 << 30);
    for (int enc in outcomes) {
      int nf = enc ~/ 100;
      int ns = enc % 100;
      List<int> el = _dp(newM, nf, ns);
      if (el[0] + 1 < earliest) earliest = el[0] + 1;
      if (el[1] + 1 > latest) latest = el[1] + 1;
    }

    List<int> result = [earliest, latest];
    _memo[key] = result;
    return result;
  }

  List<int> earliestAndLatest(int n, int firstPlayer, int secondPlayer) {
    _memo = {};
    List<int> r = _dp(n, firstPlayer, secondPlayer);
    return [r[0], r[1]];
  }
}
