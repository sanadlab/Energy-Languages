class Solution {
    fun validateBinaryTreeNodes(n: Int, leftChild: IntArray, rightChild: IntArray): Boolean {
        val m = minOf(leftChild.size, rightChild.size)
        val indeg = IntArray(n)
        for (i in 0 until m) {
            for (c in intArrayOf(leftChild[i], rightChild[i])) {
                if (c != -1) {
                    if (c < 0 || c >= n) return false
                    indeg[c]++
                    if (indeg[c] > 1) return false
                }
            }
        }
        var root = -1
        for (i in 0 until n) {
            if (indeg[i] == 0) {
                if (root != -1) return false
                root = i
            }
        }
        if (root == -1) return false
        val visited = BooleanArray(n)
        val stack = ArrayDeque<Int>()
        stack.addLast(root)
        var count = 0
        while (stack.isNotEmpty()) {
            val node = stack.removeLast()
            if (visited[node]) return false
            visited[node] = true
            count++
            if (node < m) {
                for (c in intArrayOf(leftChild[node], rightChild[node])) {
                    if (c != -1) stack.addLast(c)
                }
            }
        }
        return count == n
    }
}
