class Solution {
    public boolean isCousins(TreeNode root, int x, int y) {
        int[] dx = { -1 }, dy = { -1 };
        TreeNode[] px = { null }, py = { null };
        dfs(root, null, 0, x, y, dx, dy, px, py);
        return dx[0] == dy[0] && px[0] != py[0];
    }
    private void dfs(TreeNode node, TreeNode parent, int depth, int x, int y,
                     int[] dx, int[] dy, TreeNode[] px, TreeNode[] py) {
        if (node == null) return;
        if (node.val == x) { dx[0] = depth; px[0] = parent; }
        if (node.val == y) { dy[0] = depth; py[0] = parent; }
        dfs(node.left, node, depth + 1, x, y, dx, dy, px, py);
        dfs(node.right, node, depth + 1, x, y, dx, dy, px, py);
    }
}
