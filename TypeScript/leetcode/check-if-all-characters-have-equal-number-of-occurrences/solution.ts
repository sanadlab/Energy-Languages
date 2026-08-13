function areOccurrencesEqual(s: string): boolean {
    const cnt: Record<string, number> = {};
    for (const c of s) cnt[c] = (cnt[c] || 0) + 1;
    const vals = Object.values(cnt);
    return vals.every(v => v === vals[0]);
}
