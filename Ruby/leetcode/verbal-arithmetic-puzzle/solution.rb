# @param {String[]} words
# @param {String} result
# @return {Boolean}
def is_solvable(words, result)
    max_len = result.length
    words.each { |w| return false if w.length > max_len }
    assigned = {}
    used = Array.new(10, false)
    leading = {}
    words.each { |w| leading[w[0]] = true if w.length > 1 }
    leading[result[0]] = true if result.length > 1
    solve = nil
    solve = lambda do |col, row, carry|
        return carry == 0 if col == max_len
        if row < words.length
            w = words[row]
            return solve.call(col, row + 1, carry) if col >= w.length
            ch = w[w.length - 1 - col]
            return solve.call(col, row + 1, carry) if assigned.key?(ch)
            (0..9).each do |d|
                if !used[d] && !(d == 0 && leading[ch])
                    used[d] = true
                    assigned[ch] = d
                    return true if solve.call(col, row + 1, carry)
                    used[d] = false
                    assigned.delete(ch)
                end
            end
            return false
        end
        s = carry
        words.each { |w| s += assigned[w[w.length - 1 - col]] if col < w.length }
        digit = s % 10
        nc = s / 10
        rch = result[result.length - 1 - col]
        if assigned.key?(rch)
            return assigned[rch] == digit ? solve.call(col + 1, 0, nc) : false
        end
        return false if used[digit]
        return false if digit == 0 && leading[rch]
        used[digit] = true
        assigned[rch] = digit
        return true if solve.call(col + 1, 0, nc)
        used[digit] = false
        assigned.delete(rch)
        false
    end
    solve.call(0, 0, 0)
end
