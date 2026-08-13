function hitBricks(grid: number[][], hits: number[][]): number[] {
    const m = grid.length;
    const n = (m > 0 && Array.isArray(grid[0])) ? grid[0].length : 0;
    const total = m * n;
    const top = total;
    const parent: number[] = new Array(total + 1);
    const sz: number[] = new Array(total + 1);
    for (let i = 0; i <= total; i++) { parent[i] = i; sz[i] = 1; }

    const find = (x: number): number => {
        while (parent[x] !== x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    };
    const union = (a: number, b: number): void => {
        let ra = find(a), rb = find(b);
        if (ra === rb) return;
        if (sz[ra] < sz[rb]) { const t = ra; ra = rb; rb = t; }
        parent[rb] = ra;
        sz[ra] += sz[rb];
    };
    const inb = (r: number, c: number): boolean => r >= 0 && r < m && c >= 0 && c < n;

    const g: number[][] = [];
    for (let r = 0; r < m; r++) {
        g.push(new Array(n).fill(0));
        const row: number[] = Array.isArray(grid[r]) ? grid[r] : [];
        for (let c = 0; c < n && c < row.length; c++) if (row[c] === 1) g[r][c] = 1;
    }

    for (const h of hits) {
        if (!Array.isArray(h) || h.length < 2) continue;
        const r = h[0], c = h[1];
        if (inb(r, c)) g[r][c] = 0;
    }

    for (let r = 0; r < m; r++)
        for (let c = 0; c < n; c++)
            if (g[r][c] === 1) {
                const cur = r * n + c;
                if (r === 0) union(cur, top);
                if (r > 0 && g[r - 1][c] === 1) union(cur, (r - 1) * n + c);
                if (c > 0 && g[r][c - 1] === 1) union(cur, r * n + c - 1);
            }

    const dirs: number[][] = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    const res: number[] = new Array(hits.length).fill(0);
    for (let i = hits.length - 1; i >= 0; i--) {
        const h = hits[i];
        if (!Array.isArray(h) || h.length < 2) continue;
        const r = h[0], c = h[1];
        if (!inb(r, c)) continue;
        if (!(Array.isArray(grid[r]) && grid[r][c] === 1)) continue;
        const before = sz[find(top)];
        g[r][c] = 1;
        const cur = r * n + c;
        if (r === 0) union(cur, top);
        for (const d of dirs) {
            const nr = r + d[0], nc = c + d[1];
            if (inb(nr, nc) && g[nr][nc] === 1) union(cur, nr * n + nc);
        }
        const after = sz[find(top)];
        const f = after - before - 1;
        res[i] = f > 0 ? f : 0;
    }
    return res;
}
