function minStickers(stickers: string[], target: string): number {
    const n = target.length;
    const full = (1 << n) - 1;
    const INF = Infinity;
    const dp: number[] = new Array(1 << n).fill(INF);
    dp[0] = 0;
    const cnt: number[][] = [];
    for (const s of stickers) {
        const c = new Array(26).fill(0);
        for (const ch of s) c[ch.charCodeAt(0) - 97]++;
        cnt.push(c);
    }
    for (let state = 0; state <= full; state++) {
        if (dp[state] === INF) continue;
        for (let j = 0; j < cnt.length; j++) {
            const avail = cnt[j].slice();
            let nxt = state;
            for (let i = 0; i < n; i++) {
                if ((state & (1 << i)) === 0) {
                    const c = target.charCodeAt(i) - 97;
                    if (avail[c] > 0) { avail[c]--; nxt |= (1 << i); }
                }
            }
            if (dp[state] + 1 < dp[nxt]) dp[nxt] = dp[state] + 1;
        }
    }
    return dp[full] === INF ? -1 : dp[full];
}
