/**
 * Example:
 * var ti = TreeNode(5)
 * var v = ti.`val`
 * Definition for a binary tree node.
 * class TreeNode(var `val`: Int) {
 *     var left: TreeNode? = null
 *     var right: TreeNode? = null
 * }
 */
class Solution {
    fun minDepth(root: TreeNode?): Int {
        if (root == null) return 0
        val q = ArrayDeque<TreeNode>()
        q.add(root)
        var depth = 1
        while (q.isNotEmpty()) {
            val sz = q.size
            for (i in 0 until sz) {
                val node = q.removeFirst()
                if (node.left == null && node.right == null) return depth
                node.left?.let { q.add(it) }
                node.right?.let { q.add(it) }
            }
            depth++
        }
        return depth
    }
}
