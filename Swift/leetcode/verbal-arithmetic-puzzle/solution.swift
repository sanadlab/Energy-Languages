class Solution {
    func isSolvable(_ words: [String], _ result: String) -> Bool {
        let wordChars = words.map { Array($0) }
        let resultChars = Array(result)
        let maxLen = resultChars.count
        for w in wordChars {
            if w.count > maxLen {
                return false
            }
        }
        var assigned = [Character: Int]()
        var used = [Bool](repeating: false, count: 10)
        var leading = Set<Character>()
        for w in wordChars {
            if w.count > 1 {
                leading.insert(w[0])
            }
        }
        if resultChars.count > 1 {
            leading.insert(resultChars[0])
        }
        let numWords = wordChars.count

        func solve(_ col: Int, _ row: Int, _ carry: Int) -> Bool {
            if col == maxLen {
                return carry == 0
            }
            if row < numWords {
                let w = wordChars[row]
                if col >= w.count {
                    return solve(col, row + 1, carry)
                }
                let ch = w[w.count - 1 - col]
                if assigned[ch] != nil {
                    return solve(col, row + 1, carry)
                }
                for d in 0..<10 {
                    if !used[d] && !(d == 0 && leading.contains(ch)) {
                        used[d] = true
                        assigned[ch] = d
                        if solve(col, row + 1, carry) {
                            return true
                        }
                        used[d] = false
                        assigned[ch] = nil
                    }
                }
                return false
            }
            var s = carry
            for w in wordChars {
                if col < w.count {
                    s += assigned[w[w.count - 1 - col]]!
                }
            }
            let digit = s % 10
            let newCarry = s / 10
            let rch = resultChars[maxLen - 1 - col]
            if let a = assigned[rch] {
                if a == digit {
                    return solve(col + 1, 0, newCarry)
                }
                return false
            }
            if used[digit] {
                return false
            }
            if digit == 0 && leading.contains(rch) {
                return false
            }
            used[digit] = true
            assigned[rch] = digit
            if solve(col + 1, 0, newCarry) {
                return true
            }
            used[digit] = false
            assigned[rch] = nil
            return false
        }
        return solve(0, 0, 0)
    }
}
