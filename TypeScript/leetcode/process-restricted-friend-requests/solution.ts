function friendRequests(n: number, restrictions: number[][], requests: number[][]): boolean[] {
    const parent: number[] = [];
    for (let i = 0; i < n; i++) parent[i] = i;
    const find = (x: number): number => {
        while (parent[x] !== x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    };
    const res: boolean[] = [];
    for (const req of requests) {
        const u = req[0], v = req[1];
        const pu = find(u), pv = find(v);
        if (pu === pv) { res.push(true); continue; }
        let ok = true;
        for (const r of restrictions) {
            const px = find(r[0]), py = find(r[1]);
            if ((px === pu && py === pv) || (px === pv && py === pu)) { ok = false; break; }
        }
        if (ok) { parent[pu] = pv; res.push(true); }
        else res.push(false);
    }
    return res;
}
