public class Solution {
    public int MinDepth(TreeNode root) {
        if (root == null) return 0;
        var q = new Queue<TreeNode>();
        q.Enqueue(root);
        int depth = 1;
        while (q.Count > 0) {
            int sz = q.Count;
            for (int i = 0; i < sz; i++) {
                var node = q.Dequeue();
                if (node.left == null && node.right == null) return depth;
                if (node.left != null) q.Enqueue(node.left);
                if (node.right != null) q.Enqueue(node.right);
            }
            depth++;
        }
        return depth;
    }
}
