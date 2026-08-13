function minOperations(s: string): number {
    let cnt = 0;
    const n = s.length;
    for (let i = 0; i < n; i++) {
        const expected = (i % 2 === 0) ? '0' : '1';
        if (s[i] !== expected) cnt++;
    }
    return Math.min(cnt, n - cnt);
}
