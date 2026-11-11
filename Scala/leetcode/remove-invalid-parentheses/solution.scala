object Solution {
    def removeInvalidParentheses(s: String): List[String] = {
        def valid(t: String): Boolean = {
            var c = 0; var i = 0
            while (i < t.length && c >= 0) { val ch = t(i); if (ch == '(') c += 1 else if (ch == ')') c -= 1; i += 1 }
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
