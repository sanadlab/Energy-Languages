class Solution {
    fun isSolvable(words: Array<String>, result: String): Boolean {
        val maxLen = result.length
        for (w in words) {
            if (w.length > maxLen) return false
        }
        val assigned = HashMap<Char, Int>()
        val used = BooleanArray(10)
        val leading = HashSet<Char>()
        for (w in words) {
            if (w.length > 1) leading.add(w[0])
        }
        if (result.length > 1) leading.add(result[0])

        fun solve(col: Int, row: Int, carry: Int): Boolean {
            if (col == maxLen) {
                return carry == 0
            }
            if (row < words.size) {
                val w = words[row]
                if (col >= w.length) {
                    return solve(col, row + 1, carry)
                }
                val ch = w[w.length - 1 - col]
                if (assigned.containsKey(ch)) {
                    return solve(col, row + 1, carry)
                }
                for (d in 0 until 10) {
                    if (!used[d] && !(d == 0 && ch in leading)) {
                        used[d] = true
                        assigned[ch] = d
                        if (solve(col, row + 1, carry)) {
                            return true
                        }
                        used[d] = false
                        assigned.remove(ch)
                    }
                }
                return false
            }
            var s = carry
            for (w in words) {
                if (col < w.length) {
                    s += assigned[w[w.length - 1 - col]]!!
                }
            }
            val digit = s % 10
            val newCarry = s / 10
            val rch = result[maxLen - 1 - col]
            if (assigned.containsKey(rch)) {
                if (assigned[rch] == digit) {
                    return solve(col + 1, 0, newCarry)
                }
                return false
            }
            if (used[digit]) {
                return false
            }
            if (digit == 0 && rch in leading) {
                return false
            }
            used[digit] = true
            assigned[rch] = digit
            if (solve(col + 1, 0, newCarry)) {
                return true
            }
            used[digit] = false
            assigned.remove(rch)
            return false
        }

        return solve(0, 0, 0)
    }
}
