class StreamChecker(words: Array<String>) {

    private class Node {
        val children = HashMap<Char, Node>()
        var isEnd = false
    }

    private val root = Node()
    private val stream = StringBuilder()
    private var maxLen = 0

    init {
        for (w in words) {
            var node = root
            for (ch in w.reversed()) {
                node = node.children.getOrPut(ch) { Node() }
            }
            node.isEnd = true
            if (w.length > maxLen) maxLen = w.length
        }
    }

    fun query(letter: Char): Boolean {
        stream.append(letter)
        var node = root
        val n = stream.length
        val limit = minOf(maxLen, n)
        for (step in 0 until limit) {
            val ch = stream[n - 1 - step]
            val next = node.children[ch] ?: return false
            node = next
            if (node.isEnd) return true
        }
        return false
    }

}

/**
 * Your StreamChecker object will be instantiated and called as such:
 * var obj = StreamChecker(words)
 * var param_1 = obj.query(letter)
 */
