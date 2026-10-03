class Solution {
  List<bool> friendRequests(
      int n, List<List<int>> restrictions, List<List<int>> requests) {
    List<int> parent = List<int>.generate(n, (i) => i);

    int find(int x) {
      while (parent[x] != x) {
        parent[x] = parent[parent[x]];
        x = parent[x];
      }
      return x;
    }

    List<bool> res = [];
    for (final req in requests) {
      int u = req[0], v = req[1];
      int pu = find(u), pv = find(v);
      if (pu == pv) {
        res.add(true);
        continue;
      }
      bool ok = true;
      for (final r in restrictions) {
        int px = find(r[0]), py = find(r[1]);
        if ((px == pu && py == pv) || (px == pv && py == pu)) {
          ok = false;
          break;
        }
      }
      if (ok) {
        parent[pu] = pv;
        res.add(true);
      } else {
        res.add(false);
      }
    }
    return res;
  }
}
