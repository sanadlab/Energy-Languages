/**
 * @param {number} n
 * @param {number} firstPlayer
 * @param {number} secondPlayer
 * @return {number[]}
 */
var earliestAndLatest = function(n, firstPlayer, secondPlayer) {
    const memo = new Map();
    const dp = (m, f, s) => {
        if (f > s) { const t = f; f = s; s = t; }
        if (f + s === m + 1) return [1, 1];
        const key = m * 10000 + f * 100 + s;
        if (memo.has(key)) return memo.get(key);
        const newM = (m + 1) >> 1;
        const groups = [];
        for (let p = 1; p <= (m >> 1); p++) {
            const q = m + 1 - p;
            if (f === p || f === q) groups.push([f]);
            else if (s === p || s === q) groups.push([s]);
            else groups.push([p, q]);
        }
        if (m % 2 === 1) groups.push([(m + 1) >> 1]);
        let combos = [[]];
        for (const g of groups) {
            const next = [];
            for (const c of combos) for (const x of g) next.push(c.concat(x));
            combos = next;
        }
        const outcomes = new Set();
        for (const combo of combos) {
            let bf = 0, bs = 0;
            for (const w of combo) { if (w < f) bf++; if (w < s) bs++; }
            outcomes.add((bf + 1) * 100 + (bs + 1));
        }
        let earliest = Infinity, latest = -Infinity;
        for (const enc of outcomes) {
            const nf = Math.floor(enc / 100), ns = enc % 100;
            const r = dp(newM, nf, ns);
            earliest = Math.min(earliest, r[0] + 1);
            latest = Math.max(latest, r[1] + 1);
        }
        const res = [earliest, latest];
        memo.set(key, res);
        return res;
    };
    return dp(n, firstPlayer, secondPlayer);
};
