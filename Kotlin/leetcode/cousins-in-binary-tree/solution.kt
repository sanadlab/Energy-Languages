class Solution {
    fun isCousins(root: TreeNode?, x: Int, y: Int): Boolean {
        var dx = -1; var dy = -1; var px: TreeNode? = null; var py: TreeNode? = null
        fun dfs(n: TreeNode?, p: TreeNode?, d: Int) {
            if (n == null) return
            if (n.`val` == x) { dx = d; px = p }
            if (n.`val` == y) { dy = d; py = p }
            dfs(n.left, n, d+1); dfs(n.right, n, d+1)
        }
        dfs(root, null, 0)
        return dx == dy && px !== py
    }
}
