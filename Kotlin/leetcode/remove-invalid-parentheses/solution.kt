class Solution {
    fun removeInvalidParentheses(s: String): List<String> {
        fun valid(st: String): Boolean {
            var cnt = 0
            for (ch in st) {
                if (ch == '(') {
                    cnt++
                } else if (ch == ')') {
                    cnt--
                    if (cnt < 0) return false
                }
            }
            return cnt == 0
        }

        var level: Set<String> = setOf(s)
        while (level.isNotEmpty()) {
            val valids = level.filter { valid(it) }
            if (valids.isNotEmpty()) return valids
            val nxt = HashSet<String>()
            for (st in level) {
                for (i in st.indices) {
                    if (st[i] == '(' || st[i] == ')') {
                        nxt.add(st.substring(0, i) + st.substring(i + 1))
                    }
                }
            }
            level = nxt
        }
        return listOf("")
    }
}
