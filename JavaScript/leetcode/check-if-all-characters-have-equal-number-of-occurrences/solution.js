var areOccurrencesEqual = function(s) {
    const freq = new Map();
    for (const ch of s) {
        freq.set(ch, (freq.get(ch) || 0) + 1);
    }
    const values = Array.from(freq.values());
    const first = values[0];
    for (const v of values) {
        if (v !== first) return false;
    }
    return true;
};