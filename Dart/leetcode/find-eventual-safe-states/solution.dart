import 'dart:collection';

class Solution {
  List<int> eventualSafeNodes(List<List<int>> graph) {
    final int n = graph.length;
    final List<List<int>> rev = List.generate(n, (_) => <int>[]);
    final List<int> outdeg = List.filled(n, 0);
    for (int u = 0; u < n; u++) {
      for (final v in graph[u]) {
        if (0 <= v && v < n) {
          rev[v].add(u);
          outdeg[u] += 1;
        }
      }
    }
    final Queue<int> q = Queue<int>();
    for (int i = 0; i < n; i++) {
      if (outdeg[i] == 0) {
        q.add(i);
      }
    }
    final List<bool> safe = List.filled(n, false);
    while (q.isNotEmpty) {
      final int v = q.removeFirst();
      safe[v] = true;
      for (final u in rev[v]) {
        outdeg[u] -= 1;
        if (outdeg[u] == 0) {
          q.add(u);
        }
      }
    }
    final List<int> result = [];
    for (int i = 0; i < n; i++) {
      if (safe[i]) {
        result.add(i);
      }
    }
    return result;
  }
}
