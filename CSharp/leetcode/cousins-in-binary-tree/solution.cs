/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public int val;
 *     public TreeNode left;
 *     public TreeNode right;
 *     public TreeNode(int val=0, TreeNode left=null, TreeNode right=null) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
public class Solution {
    public bool IsCousins(TreeNode root, int x, int y) {
        if (root == null) return false;
        
        // Store parent and depth info for x and y
        (TreeNode parent, int depth) xInfo = (null, -1);
        (TreeNode parent, int depth) yInfo = (null, -1);
        
        void DFS(TreeNode node, TreeNode parent, int depth) {
            if (node == null) return;
            if (node.val == x) xInfo = (parent, depth);
            if (node.val == y) yInfo = (parent, depth);
            DFS(node.left, node, depth + 1);
            DFS(node.right, node, depth + 1);
        }
        
        DFS(root, null, 0);
        
        return xInfo.depth == yInfo.depth && xInfo.parent != yInfo.parent;
    }
}