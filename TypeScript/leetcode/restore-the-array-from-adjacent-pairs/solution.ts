function restoreArray(adjacentPairs: number[][]): number[] {
    const adj = new Map<number, number[]>();
    for (const [u, v] of adjacentPairs) {
        if (!adj.has(u)) adj.set(u, []);
        if (!adj.has(v)) adj.set(v, []);
        adj.get(u)!.push(v);
        adj.get(v)!.push(u);
    }
    const n = adjacentPairs.length + 1;
    let start = adjacentPairs.length > 0 ? adjacentPairs[0][0] : 0;
    for (const [node, nbrs] of adj) {
        if (nbrs.length === 1) { start = node; break; }
    }
    const res: number[] = [start];
    let prev = start, cur = start, hasPrev = false;
    while (res.length < n) {
        let nxt: number | null = null;
        const nbrs = adj.get(cur);
        if (nbrs) {
            for (const x of nbrs) {
                if (!hasPrev || x !== prev) { nxt = x; break; }
            }
        }
        if (nxt === null) break;
        res.push(nxt);
        prev = cur; hasPrev = true; cur = nxt;
    }
    return res;
}
