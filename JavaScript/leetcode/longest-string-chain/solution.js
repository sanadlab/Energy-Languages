/**
 * @param {string[]} words
 * @return {number}
 */
var longestStrChain = function(words) {
    words.sort((a, b) => a.length - b.length);
    const dp = new Map();
    let best = 1;
    for (const w of words) {
        let cur = 1;
        for (let i = 0; i < w.length; i++) {
            const pred = w.slice(0, i) + w.slice(i + 1);
            if (dp.has(pred)) cur = Math.max(cur, dp.get(pred) + 1);
        }
        dp.set(w, cur);
        best = Math.max(best, cur);
    }
    return best;
};
