function diStringMatch(s: string): number[] {
    const n = s.length;
    let lo = 0, hi = n;
    const res: number[] = [];
    for (let i = 0; i < n; i++) {
        if (s[i] === 'I') res.push(lo++);
        else res.push(hi--);
    }
    res.push(lo);
    return res;
}
