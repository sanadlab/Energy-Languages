object Solution {
    def validateBinaryTreeNodes(n: Int, leftChild: Array[Int], rightChild: Array[Int]): Boolean = {
        val m = math.min(leftChild.length, rightChild.length)
        val indeg = Array.fill(n)(0)
        var i = 0
        while (i < m) {
            var ci = 0
            while (ci < 2) {
                val c = if (ci == 0) leftChild(i) else rightChild(i)
                if (c != -1) {
                    if (c < 0 || c >= n) return false
                    indeg(c) += 1
                    if (indeg(c) > 1) return false
                }
                ci += 1
            }
            i += 1
        }
        var root = -1
        var k = 0
        while (k < n) {
            if (indeg(k) == 0) {
                if (root != -1) return false
                root = k
            }
            k += 1
        }
        if (root == -1) return false
        val visited = Array.fill(n)(false)
        val stack = scala.collection.mutable.ArrayBuffer[Int](root)
        var count = 0
        while (stack.nonEmpty) {
            val node = stack.remove(stack.length - 1)
            if (visited(node)) return false
            visited(node) = true
            count += 1
            if (node < m) {
                var ci = 0
                while (ci < 2) {
                    val c = if (ci == 0) leftChild(node) else rightChild(node)
                    if (c != -1) stack += c
                    ci += 1
                }
            }
        }
        count == n
    }
}
