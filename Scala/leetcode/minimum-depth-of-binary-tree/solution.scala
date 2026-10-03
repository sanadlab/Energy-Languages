object Solution {
    def minDepth(root: TreeNode): Int = {
        if (root == null) return 0
        val q = scala.collection.mutable.Queue[TreeNode]()
        q.enqueue(root)
        var depth = 1
        while (q.nonEmpty) {
            val sz = q.size
            var i = 0
            while (i < sz) {
                val node = q.dequeue()
                if (node.left == null && node.right == null) return depth
                if (node.left != null) q.enqueue(node.left)
                if (node.right != null) q.enqueue(node.right)
                i += 1
            }
            depth += 1
        }
        depth
    }
}
