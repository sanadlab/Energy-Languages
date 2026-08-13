/**
 * @param {character[][]} seats
 * @return {number}
 */
var maxStudents = function(seats) {
    const m = seats.length;
    if (m === 0) return 0;
    const n = seats[0].length;
    const avail = new Array(m).fill(0);
    for (let i = 0; i < m; i++)
        for (let j = 0; j < n && j < seats[i].length; j++)
            if (seats[i][j] === '.') avail[i] |= (1 << j);
    const full = 1 << n;
    const popcount = x => { let c = 0; while (x) { x &= x - 1; c++; } return c; };
    let best = new Array(full).fill(-1);
    best[0] = 0;
    for (let i = 0; i < m; i++) {
        const ndp = new Array(full).fill(-1);
        for (let mask = 0; mask < full; mask++) {
            if ((mask & avail[i]) !== mask) continue;
            if ((mask & (mask << 1)) !== 0) continue;
            const pc = popcount(mask);
            for (let pmask = 0; pmask < full; pmask++) {
                if (best[pmask] < 0) continue;
                if ((mask & (pmask << 1)) !== 0) continue;
                if ((mask & (pmask >> 1)) !== 0) continue;
                const val = best[pmask] + pc;
                if (val > ndp[mask]) ndp[mask] = val;
            }
        }
        best = ndp;
    }
    return Math.max(...best);
};
