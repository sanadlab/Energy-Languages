class Solution {
  bool isCousins(TreeNode? root, int x, int y) {
    int dx = -1, dy = -1;
    TreeNode? px, py;
    List<List<dynamic>> stack = [
      [root, null, 0]
    ];
    while (stack.isNotEmpty) {
      var frame = stack.removeLast();
      TreeNode? node = frame[0] as TreeNode?;
      TreeNode? parent = frame[1] as TreeNode?;
      int depth = frame[2] as int;
      if (node == null) continue;
      if (node.val == x) {
        dx = depth;
        px = parent;
      }
      if (node.val == y) {
        dy = depth;
        py = parent;
      }
      stack.add([node.left, node, depth + 1]);
      stack.add([node.right, node, depth + 1]);
    }
    return dx == dy && !identical(px, py);
  }
}
