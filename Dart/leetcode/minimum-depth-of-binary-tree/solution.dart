class Solution {
  int minDepth(TreeNode? root) {
    if (root == null) return 0;
    var q = <TreeNode>[root];
    int depth = 1;
    while (q.isNotEmpty) {
      final next = <TreeNode>[];
      for (final n in q) {
        if (n.left == null && n.right == null) return depth;
        if (n.left != null) next.add(n.left!);
        if (n.right != null) next.add(n.right!);
      }
      q = next;
      depth++;
    }
    return depth;
  }
}
