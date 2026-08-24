object Solution {
    def removeInvalidParentheses(s: String): List[String] = {
        def valid(t: String): Boolean = {
            var c = 0
            for (ch <- t) { if (ch == '(') c += 1 else if (ch == ')') { c -= 1; if (c < 0) return false } }
            c == 0
        }
        var level = Set(s)
        while (true) {
            val found = level.filter(valid)
            if (found.nonEmpty) return found.toList
            val nxt = scala.collection.mutable.Set[String]()
            for (t <- level; i <- 0 until t.length if t(i) == '(' || t(i) == ')')
                nxt += (t.substring(0, i) + t.substring(i + 1))
            if (nxt.isEmpty) return List("")
            level = nxt.toSet
        }
        List("")
    }
}
