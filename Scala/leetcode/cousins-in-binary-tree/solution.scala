object Solution {
    def isCousins(root: TreeNode, x: Int, y: Int): Boolean = {
        var dx = -1; var dy = -1; var px: TreeNode = null; var py: TreeNode = null
        def dfs(n: TreeNode, p: TreeNode, d: Int): Unit = {
            if (n == null) return
            if (n.value == x) { dx = d; px = p }
            if (n.value == y) { dy = d; py = p }
            dfs(n.left, n, d + 1); dfs(n.right, n, d + 1)
        }
        dfs(root, null, 0)
        dx == dy && (px ne py)
    }
}
