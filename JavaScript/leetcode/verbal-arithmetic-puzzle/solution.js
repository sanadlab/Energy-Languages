/**
 * @param {string[]} words
 * @param {string} result
 * @return {boolean}
 */
var isSolvable = function(words, result) {
    const maxLen = result.length;
    for (const w of words) if (w.length > maxLen) return false;
    const assigned = {};
    const used = new Array(10).fill(false);
    const leading = new Set();
    for (const w of words) if (w.length > 1) leading.add(w[0]);
    if (result.length > 1) leading.add(result[0]);

    const solve = (col, row, carry) => {
        if (col === maxLen) return carry === 0;
        if (row < words.length) {
            const w = words[row];
            if (col >= w.length) return solve(col, row + 1, carry);
            const ch = w[w.length - 1 - col];
            if (ch in assigned) return solve(col, row + 1, carry);
            for (let d = 0; d <= 9; d++) {
                if (!used[d] && !(d === 0 && leading.has(ch))) {
                    used[d] = true;
                    assigned[ch] = d;
                    if (solve(col, row + 1, carry)) return true;
                    used[d] = false;
                    delete assigned[ch];
                }
            }
            return false;
        }
        let s = carry;
        for (const w of words) if (col < w.length) s += assigned[w[w.length - 1 - col]];
        const digit = s % 10, nc = Math.floor(s / 10);
        const rch = result[result.length - 1 - col];
        if (rch in assigned) {
            if (assigned[rch] === digit) return solve(col + 1, 0, nc);
            return false;
        }
        if (used[digit]) return false;
        if (digit === 0 && leading.has(rch)) return false;
        used[digit] = true;
        assigned[rch] = digit;
        if (solve(col + 1, 0, nc)) return true;
        used[digit] = false;
        delete assigned[rch];
        return false;
    };
    return solve(0, 0, 0);
};
