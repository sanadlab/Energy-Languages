class Solution {
  bool validateBinaryTreeNodes(int n, List<int> leftChild, List<int> rightChild) {
    int m = leftChild.length < rightChild.length
        ? leftChild.length
        : rightChild.length;
    List<int> indeg = List<int>.filled(n, 0);
    for (int i = 0; i < m; i++) {
      for (int c in [leftChild[i], rightChild[i]]) {
        if (c != -1) {
          if (c < 0 || c >= n) return false;
          indeg[c] += 1;
          if (indeg[c] > 1) return false;
        }
      }
    }
    int root = -1;
    for (int i = 0; i < n; i++) {
      if (indeg[i] == 0) {
        if (root != -1) return false;
        root = i;
      }
    }
    if (root == -1) return false;
    List<bool> visited = List<bool>.filled(n, false);
    List<int> stack = [root];
    int count = 0;
    while (stack.isNotEmpty) {
      int node = stack.removeLast();
      if (visited[node]) return false;
      visited[node] = true;
      count += 1;
      if (node < m) {
        for (int c in [leftChild[node], rightChild[node]]) {
          if (c != -1) stack.add(c);
        }
      }
    }
    return count == n;
  }
}
