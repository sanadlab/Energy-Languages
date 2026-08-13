function eventualSafeNodes(graph: number[][]): number[] {
    const n = graph.length;
    const rev: number[][] = Array.from({ length: n }, () => []);
    const outdeg: number[] = new Array(n).fill(0);
    for (let u = 0; u < n; u++) {
        for (const v of graph[u]) {
            if (v >= 0 && v < n) {
                rev[v].push(u);
                outdeg[u]++;
            }
        }
    }
    const queue: number[] = [];
    for (let i = 0; i < n; i++) if (outdeg[i] === 0) queue.push(i);
    const safe: boolean[] = new Array(n).fill(false);
    let head = 0;
    while (head < queue.length) {
        const v = queue[head++];
        safe[v] = true;
        for (const u of rev[v]) {
            if (--outdeg[u] === 0) queue.push(u);
        }
    }
    const res: number[] = [];
    for (let i = 0; i < n; i++) if (safe[i]) res.push(i);
    return res;
}
