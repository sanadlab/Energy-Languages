function kWeakestRows(mat: number[][], k: number): number[] {
    const rows: [number, number][] = mat.map((row, i) => [row.reduce((a, v) => a + (v === 1 ? 1 : 0), 0), i]);
    rows.sort((a, b) => a[0] - b[0] || a[1] - b[1]);
    return rows.slice(0, Math.min(k, rows.length)).map(r => r[1]);
}
