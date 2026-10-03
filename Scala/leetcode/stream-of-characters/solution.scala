class StreamChecker(_words: Array[String]) {

    private class Node {
        val children = scala.collection.mutable.HashMap[Char, Node]()
        var isWord = false
    }
    private val root = new Node()
    private var maxLen = 0
    private val stream = scala.collection.mutable.ArrayBuffer[Char]()
    for (w <- _words) {
        var node = root
        var i = w.length - 1
        while (i >= 0) {
            node = node.children.getOrElseUpdate(w(i), new Node())
            i -= 1
        }
        node.isWord = true
        if (w.length > maxLen) maxLen = w.length
    }

    def query(letter: Char): Boolean = {
        stream += letter
        var node = root
        val n = stream.length
        val steps = math.min(maxLen, n)
        var step = 0
        var result = false
        var broken = false
        while (step < steps && !broken && !result) {
            val ch = stream(n - 1 - step)
            node.children.get(ch) match {
                case None => broken = true
                case Some(next) =>
                    node = next
                    if (node.isWord) result = true
            }
            step += 1
        }
        result
    }

}

/**
 * Your StreamChecker object will be instantiated and called as such:
 * val obj = new StreamChecker(words)
 * val param_1 = obj.query(letter)
 */
