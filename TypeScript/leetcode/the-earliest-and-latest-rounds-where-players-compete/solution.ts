function earliestAndLatest(n: number, firstPlayer: number, secondPlayer: number): number[] {
    // Exact recursion over the positions of the two players: each round, every
    // other match may go either way, so enumerate how many winners finish ahead
    // of each player (only those counts matter for the next round).
    const memo = new Map<number, [number, number]>();
    const dp = (m: number, f: number, s: number): [number, number] => {
        if (f > s) { const t = f; f = s; s = t; }
        if (f + s === m + 1) return [1, 1];
        const key = m * 10000 + f * 100 + s;
        const hit = memo.get(key);
        if (hit) return hit;
        let states = new Set<number>([0]);            // bf * 100 + bs
        const step = (opts: number[]) => {
            const next = new Set<number>();
            for (const st of states) {
                const bf = Math.floor(st / 100), bs = st % 100;
                for (const w of opts) next.add((bf + (w < f ? 1 : 0)) * 100 + bs + (w < s ? 1 : 0));
            }
            states = next;
        };
        for (let p = 1; p <= (m >> 1); p++) {
            const q = m + 1 - p;
            if (p === f || q === f) step([f]);
            else if (p === s || q === s) step([s]);
            else step([p, q]);
        }
        if (m % 2 === 1) step([(m + 1) >> 1]);
        let earliest = Infinity, latest = -Infinity;
        for (const st of states) {
            const [e, l] = dp((m + 1) >> 1, Math.floor(st / 100) + 1, (st % 100) + 1);
            earliest = Math.min(earliest, e + 1);
            latest = Math.max(latest, l + 1);
        }
        const res: [number, number] = [earliest, latest];
        memo.set(key, res);
        return res;
    };
    return dp(n, firstPlayer, secondPlayer);
}
