function isSolvable(words: string[], result: string): boolean {
    const maxLen = result.length;
    const assigned: number[] = new Array(128).fill(-1);
    const usedDigit: boolean[] = new Array(10).fill(false);
    const leading: boolean[] = new Array(128).fill(false);
    for (const w of words) {
        if (w.length > maxLen) return false;
        if (w.length > 1) leading[w.charCodeAt(0)] = true;
    }
    if (result.length > 1) leading[result.charCodeAt(0)] = true;

    const solve = (col: number, row: number, carry: number): boolean => {
        if (col === maxLen) return carry === 0;
        if (row < words.length) {
            const w = words[row];
            if (col >= w.length) return solve(col, row + 1, carry);
            const ch = w.charCodeAt(w.length - 1 - col);
            if (assigned[ch] !== -1) return solve(col, row + 1, carry);
            for (let d = 0; d <= 9; d++) {
                if (!usedDigit[d] && !(d === 0 && leading[ch])) {
                    usedDigit[d] = true;
                    assigned[ch] = d;
                    if (solve(col, row + 1, carry)) return true;
                    usedDigit[d] = false;
                    assigned[ch] = -1;
                }
            }
            return false;
        }
        let sum = carry;
        for (const w of words) {
            if (col < w.length) sum += assigned[w.charCodeAt(w.length - 1 - col)];
        }
        const digit = sum % 10;
        const newCarry = Math.floor(sum / 10);
        const rch = result.charCodeAt(result.length - 1 - col);
        if (assigned[rch] !== -1) {
            if (assigned[rch] === digit) return solve(col + 1, 0, newCarry);
            return false;
        }
        if (usedDigit[digit]) return false;
        if (digit === 0 && leading[rch]) return false;
        usedDigit[digit] = true;
        assigned[rch] = digit;
        if (solve(col + 1, 0, newCarry)) return true;
        usedDigit[digit] = false;
        assigned[rch] = -1;
        return false;
    };
    return solve(0, 0, 0);
}
