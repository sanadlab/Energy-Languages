object Solution {
    def isSolvable(words: Array[String], result: String): Boolean = {
        val maxLen = result.length
        if (words.exists(_.length > maxLen)) return false
        val assigned = scala.collection.mutable.HashMap[Char, Int]()
        val used = Array.fill(10)(false)
        val leading = scala.collection.mutable.Set[Char]()
        for (w <- words) {
            if (w.length > 1) leading.add(w(0))
        }
        if (result.length > 1) leading.add(result(0))

        def solve(col: Int, row: Int, carry: Int): Boolean = {
            if (col == maxLen) {
                carry == 0
            } else if (row < words.length) {
                val w = words(row)
                if (col >= w.length) {
                    solve(col, row + 1, carry)
                } else {
                    val ch = w(w.length - 1 - col)
                    if (assigned.contains(ch)) {
                        solve(col, row + 1, carry)
                    } else {
                        var d = 0
                        var found = false
                        while (d < 10 && !found) {
                            if (!used(d) && !(d == 0 && leading.contains(ch))) {
                                used(d) = true
                                assigned(ch) = d
                                if (solve(col, row + 1, carry)) {
                                    found = true
                                } else {
                                    used(d) = false
                                    assigned.remove(ch)
                                }
                            }
                            d += 1
                        }
                        found
                    }
                }
            } else {
                var s = carry
                for (w <- words) {
                    if (col < w.length) {
                        s += assigned(w(w.length - 1 - col))
                    }
                }
                val digit = s % 10
                val newCarry = s / 10
                val rch = result(maxLen - 1 - col)
                if (assigned.contains(rch)) {
                    if (assigned(rch) == digit) solve(col + 1, 0, newCarry)
                    else false
                } else if (used(digit)) {
                    false
                } else if (digit == 0 && leading.contains(rch)) {
                    false
                } else {
                    used(digit) = true
                    assigned(rch) = digit
                    if (solve(col + 1, 0, newCarry)) {
                        true
                    } else {
                        used(digit) = false
                        assigned.remove(rch)
                        false
                    }
                }
            }
        }
        solve(0, 0, 0)
    }
}
