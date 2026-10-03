class Solution {
  List<int> restoreArray(List<List<int>> adjacentPairs) {
    final adj = <int, List<int>>{};
    for (final pair in adjacentPairs) {
      final u = pair[0], v = pair[1];
      (adj[u] ??= <int>[]).add(v);
      (adj[v] ??= <int>[]).add(u);
    }
    final n = adjacentPairs.length + 1;
    var start = adjacentPairs.isNotEmpty ? adjacentPairs[0][0] : 0;
    for (final entry in adj.entries) {
      if (entry.value.length == 1) {
        start = entry.key;
        break;
      }
    }
    final res = <int>[start];
    var prev = start;
    var cur = start;
    var hasPrev = false;
    while (res.length < n) {
      int? nxt;
      for (final x in adj[cur]!) {
        if (!hasPrev || x != prev) {
          nxt = x;
          break;
        }
      }
      if (nxt == null) {
        break;
      }
      res.add(nxt);
      prev = cur;
      hasPrev = true;
      cur = nxt;
    }
    return res;
  }
}
