class Solution {
  int _gcd(int a, int b) {
    while (b != 0) {
      int t = a % b;
      a = b;
      b = t;
    }
    return a;
  }

  List<int> getCoprimes(List<int> nums, List<List<int>> edges) {
    int n = nums.length;
    List<int> ans = List<int>.filled(n, -1);
    List<List<int>> adj = List.generate(n, (_) => <int>[]);
    for (List<int> e in edges) {
      if (e.length < 2) continue;
      int u = e[0];
      int v = e[1];
      if (u >= 0 && u < n && v >= 0 && v < n) {
        adj[u].add(v);
        adj[v].add(u);
      }
    }

    // Precompute, for each value 1..50, the values coprime with it.
    List<List<int>> coprime = List.generate(51, (_) => <int>[]);
    for (int a = 1; a <= 50; a++) {
      for (int b = 1; b <= 50; b++) {
        if (_gcd(a, b) == 1) coprime[a].add(b);
      }
    }

    // Ancestor stacks indexed by VALUE; answer indexed by NODE.
    List<List<int>> depthStack = List.generate(51, (_) => <int>[]);
    List<List<int>> nodeStack = List.generate(51, (_) => <int>[]);
    if (n == 0) return ans;

    // Iterative DFS with enter/exit markers to keep ancestor stacks correct.
    // Entry: [node, parent, depth, processed(0/1)].
    List<List<int>> stack = [
      [0, -1, 0, 0]
    ];
    while (stack.isNotEmpty) {
      List<int> top = stack.removeLast();
      int node = top[0];
      int parent = top[1];
      int depth = top[2];
      int processed = top[3];
      int val = nums[node];
      if (processed == 1) {
        depthStack[val].removeLast();
        nodeStack[val].removeLast();
        continue;
      }
      int bestDepth = -1;
      int bestNode = -1;
      for (int cv in coprime[val]) {
        List<int> ds = depthStack[cv];
        if (ds.isNotEmpty && ds[ds.length - 1] > bestDepth) {
          bestDepth = ds[ds.length - 1];
          bestNode = nodeStack[cv][nodeStack[cv].length - 1];
        }
      }
      ans[node] = bestNode;
      stack.add([node, parent, depth, 1]);
      depthStack[val].add(depth);
      nodeStack[val].add(node);
      for (int nb in adj[node]) {
        if (nb != parent) {
          stack.add([nb, node, depth + 1, 0]);
        }
      }
    }
    return ans;
  }
}
